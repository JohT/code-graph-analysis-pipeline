#!/usr/bin/env bash

# Converts SCIP JSON index files (*.scip.json) in INDICES_DIRECTORY to Neo4j import CSVs in IMPORT_DIRECTORY.
# Uses occurrence-based cross-file filtering: only symbols referenced from at least one file other than
# their definition file are included as internal symbols (SemanticCodeIndexInternalSymbol).
# All symbol kinds are captured (types, functions, variables, fields, etc.) without kind-number filtering.
# Supports multiple index files: node symbols are deduplicated; edge reference counts are summed.
# Writes scip_symbol_nodes.csv, scip_symbol_edges.csv, scip_external_symbol_nodes.csv,
# and scip_projects.csv to IMPORT_DIRECTORY.
# Requires jq.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

INDICES_DIRECTORY=${INDICES_DIRECTORY:-"./indices"}
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"./import"}

## Get this "domains/scip-index-import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CONVERT_SCIP_CROSS_FILE_SCRIPT_DIR=${CONVERT_SCIP_CROSS_FILE_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "convertScipIndexToCsvForNeo4jCrossFileImport: CONVERT_SCIP_CROSS_FILE_SCRIPT_DIR=${CONVERT_SCIP_CROSS_FILE_SCRIPT_DIR}"

# ---------------------------------------------------------------------------
# jq function library
# Defined once and spliced into every jq query to avoid duplication.
# ---------------------------------------------------------------------------

JQ_CROSS_FILE_FUNCTIONS='
    def descriptor(symbol):
        symbol | split(" ") | if length >= 5 then .[4] else "" end;

    def is_base_type_descriptor(symbol):
        descriptor(symbol) | endswith("#");

    def is_type_parameter_descriptor(symbol):
        descriptor(symbol) | endswith("]");

    def is_module_level_function_descriptor(sym):
        descriptor(sym) | test("^[^#]*\\(\\)");

    def is_function_definition_descriptor(sym):
        descriptor(sym) | test("\\(\\)\\.$");

    def is_base_variable_descriptor(sym):
        descriptor(sym) | (endswith(".") and (contains("#") | not) and (contains("(") | not));

    def is_base_field_descriptor(sym):
        descriptor(sym) | test("#[^#()]+\\.$");

    def normalize_symbol(symbol):
        symbol | split(" ") |
        if length >= 5 then
            .[0:4] as $prefix |
            .[4] as $d |
            (if ($d | endswith("#")) then $d
             else ($d | split("#") | .[:-1] | join("#") + "#")
             end) as $norm |
            ($prefix + [$norm]) | join(" ")
        else
            symbol
        end;

    def short_symbol(s):
        s | split(" ") | if length >= 5 then .[2:5] | join(" ") else s end;

    def scheme(s):
        s | split(" ") | .[0];

    def scheme_to_language(s):
        if   s == "scip-go"         then "Go"
        elif s == "semanticdb"      then "Java"
        elif s == "scip-typescript" then "TypeScript"
        elif s == "rust-analyzer"   then "Rust"
        elif s == "cxx"             then "C++"
        elif s == "scip-ruby"       then "Ruby"
        elif s == "scip-python"     then "Python"
        elif s == "scip-dotnet"     then "C#"
        else s | ltrimstr("scip-") | if length > 0 then (.[0:1] | ascii_upcase) + .[1:] else . end
        end;

    def is_test(file):
        (file | contains("/test/"))    or (file | contains("/tests/"))  or
        (file | contains("/spec/"))    or (file | contains("__tests__")) or
        (file | endswith("_test.go"))  or (file | contains(".test."))   or
        (file | contains(".spec."))    or (file | contains("\\test\\")) or
        (file | contains("\\tests\\")) or (file | contains("\\spec\\"));

    def null_kind_fallback(sig_text; doc_first_line):
        if   (sig_text    // "" | test("^public final "))    then "Record"
        elif (doc_first_line // "" | test("^abstract class ")) then "AbstractClass"
        elif (doc_first_line // "" | test("^interface "))      then "Interface"
        elif (doc_first_line // "" | test("^class "))          then "Class"
        elif (doc_first_line // "" | test("^enum "))           then "Enum"
        elif (doc_first_line // "" | test("^type "))           then "TypeAlias"
        elif (doc_first_line // "" | test("^\\(method\\)"))    then "Method"
        elif (doc_first_line // "" | test("^function "))       then "Function"
        else "Unknown"
        end;

    # Classifies a symbol to a human-readable type name covering all SCIP kinds.
    # Kind 61 is TypeScript/Python specific: could be a type parameter or a field.
    # Distinguish fields (descriptor matches #name.) from other kind-61 uses.
    def code_unit_type_all(kind; sig_text; doc_first_line; sym):
        if   kind == 7  then (if (sig_text // "" | test("abstract")) then "AbstractClass" else "Class" end)
        elif kind == 8  then "Variable"
        elif kind == 9  then "Constructor"
        elif kind == 11 then "Enum"
        elif kind == 12 then "EnumMember"
        elif kind == 16 then "File"
        elif kind == 17 then "Function"
        elif kind == 18 then "Getter"
        elif kind == 21 then "Interface"
        elif kind == 26 then "Method"
        elif kind == 35 then "Package"
        elif kind == 41 then "Property"
        elif kind == 49 then "Struct"
        elif kind == 54 then "TypeAlias"
        elif kind == 55 then "TypeAlias"
        elif kind == 61 then
            if is_base_field_descriptor(sym) then "Field" else "TypeAlias" end
        elif kind == 66 then "Method"
        elif kind == 67 then "Method"
        elif kind == 79 then "Field"
        elif kind == 80 then "Method"
        elif kind == null then null_kind_fallback(sig_text; doc_first_line)
        else "Unknown"
        end;

    # Derives a human-readable display name from the symbol descriptor.
    def display_name_from_descriptor(sym):
        descriptor(sym) as $d |
        if   ($d | endswith("#"))                  then ($d | rtrimstr("#") | split("/") | last | gsub("`"; ""))
        elif ($d | test("^[^#]*\\(\\)\\.$"))       then ($d | rtrimstr(".") | rtrimstr("()") | split("/") | last | gsub("`"; ""))
        elif ($d | test("#[^#()]+\\.$"))           then ($d | split("#") | last | rtrimstr(".") | gsub("`"; ""))
        elif ($d | endswith("."))                  then ($d | rtrimstr(".") | split("/") | last | gsub("`"; ""))
        elif ($d | endswith("/"))                  then ($d | rtrimstr("/") | split("/") | last | gsub("`"; ""))
        elif ($d | endswith("]"))                  then ($d | split("[") | last | rtrimstr("]") | gsub("`"; ""))
        else ($d | split("/") | map(select(length > 0)) | last // $d | gsub("`"; ""))
        end;

    # Classifies the edge type for a reference occurrence target symbol.
    # Method references are reported as calls_method (normalized to base type at call site).
    def classify_edge_type(sym):
        descriptor(sym) as $d |
        if   ($d | endswith("#"))                               then "uses_type"
        elif ($d | test("^[^#]*\\(\\)\\.$"))                   then "calls_function"
        elif ($d | test("#[^()#]+\\(\\)"))                     then "calls_method"
        elif is_base_field_descriptor(sym)                      then "uses_field"
        elif is_base_variable_descriptor(sym)                   then "uses_variable"
        else "references"
        end;

    # Normalizes method/member references to their containing base type for edge targets.
    def edge_target(sym):
        descriptor(sym) as $d |
        if ($d | test("#[^()#]+\\(\\)")) then
            normalize_symbol(sym) | split(" ") | .[2:5] | join(" ")
        else
            short_symbol(sym)
        end;

    # True when a SCIP symbol is valid for CSV export.
    # Excludes local symbols, short symbols, and symbols containing control characters
    # such as newlines. TypeScript SCIP indexers sometimes embed multi-line type
    # literals in parameter identifiers; those break CSV line parsing.
    def is_valid_scip_symbol(sym):
        (sym | startswith("local ") | not) and
        (sym | split(" ") | length) >= 5 and
        (sym | contains("\n") | not) and
        (sym | contains("\r") | not);
'

function validate_prerequisites() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Error: jq is required but not found in PATH." >&2
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Install jq: brew install jq (macOS) or apt-get install jq (Linux)." >&2
        exit 1
    fi

    if [ ! -d "${INDICES_DIRECTORY}" ]; then
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Error: INDICES_DIRECTORY '${INDICES_DIRECTORY}' does not exist." >&2
        exit 1
    fi

    # Fail if any non-.scip.json files are present (e.g. binary .scip files), but allow .sha change-detection files
    local non_json_files
    non_json_files=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -type f ! -name "*.scip.json" ! -name "*.sha" 2>/dev/null | sort || true)
    if [ -n "${non_json_files}" ]; then
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Error: Only .scip.json files are supported in INDICES_DIRECTORY '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Found unsupported files:" >&2
        while IFS= read -r unsupported_file; do
            echo "convertScipIndexToCsvForNeo4jCrossFileImport:   - ${unsupported_file}" >&2
        done <<< "${non_json_files}"
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Remove them or convert binary .scip files using: scip print --json index.scip > index.scip.json" >&2
        exit 1
    fi

    local scip_count
    scip_count=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "${scip_count}" -lt 1 ]; then
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Error: No *.scip.json files found in '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jCrossFileImport: Generate SCIP indices outside this pipeline and place .scip.json files there." >&2
        exit 1
    fi

    echo "convertScipIndexToCsvForNeo4jCrossFileImport: Found ${scip_count} SCIP JSON index file(s) in '${INDICES_DIRECTORY}'."
}

# ---------------------------------------------------------------------------
# Pass 1 — Build the symbol information index for one input file.
#
# Extends the kind-level index with symbol_has_cross_file_reference: a boolean
# map indicating which symbols are referenced from at least one file other than
# their definition file. This is computed in two steps within a single jq call:
# - Step 1: build symbol_to_file from definition occurrences (role 1).
# - Step 2: scan reference occurrences (role 0) for symbols whose definition
#            file differs from the referencing file.
# ---------------------------------------------------------------------------

function build_symbol_information_index() {
    local input_file="${1}"
    jq "${JQ_CROSS_FILE_FUNCTIONS}"'
        # Build symbol_to_file first so we can reference it when computing
        # symbol_has_cross_file_reference in the same object.
        (
            [.documents[] |
             .relative_path as $file |
             .occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             {key: .symbol, value: $file}
            ] | reduce .[] as $kv ({}; .[$kv.key] = $kv.value)
        ) as $stf |

        {
            symbol_to_file: $stf,

            symbol_has_cross_file_reference: (
                [.documents[] |
                 .relative_path as $ref_file |
                 .occurrences[] |
                 select((.symbol_roles // 0) % 2 == 0) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 .symbol as $sym |
                 select($stf[$sym] != null) |
                 select($stf[$sym] != $ref_file) |
                 $sym
                ] | unique | map({key: ., value: true}) | from_entries
            ),

            symbol_to_kind: (
                [.documents[].symbols[]? |
                 select(.symbol != null) |
                 {key: .symbol, value: (.kind // null)}
                ] | reduce .[] as $kv ({}; .[$kv.key] = $kv.value)
            ),

            symbol_to_signature_text: (
                [.documents[].symbols[]? |
                 select(.symbol != null) |
                 select(.signature_documentation.text != null) |
                 {key: .symbol, value: .signature_documentation.text}
                ] | reduce .[] as $kv ({}; .[$kv.key] = $kv.value)
            ),

            symbol_to_doc_first_line: (
                [.documents[].symbols[]? |
                 select(.symbol != null) |
                 select((.documentation // []) | length > 0) |
                 .documentation[0] as $doc |
                 select($doc | startswith("```")) |
                 {key: .symbol, value: ($doc | split("\n") | .[1] // "")}
                ] | reduce .[] as $kv ({}; .[$kv.key] = $kv.value)
            ),

            internal_package_ids: (
                [.documents[].occurrences[] |
                 select((.symbol_roles // 0) % 2 == 1) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 .symbol | split(" ") | .[2]
                ] | unique
            ),

            directory_to_package_tokens: (
                [.documents[] |
                 .relative_path as $file |
                 ($file | split("/") | .[:-1] | join("/")) as $dir |
                 .occurrences[] |
                 select((.symbol_roles // 0) % 2 == 1) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 {key: $dir, value: (.symbol | split(" ") | .[0:4])}
                ] | reduce .[] as $kv ({}; .[$kv.key] //= $kv.value)
            ),

            project_root: (
                (.metadata.project_root // "unknown") as $raw |
                if ($raw | test("file://")) then
                    ($raw | gsub("^file://"; ""))
                else
                    $raw
                end
                | gsub("/$"; "")
            )
        }
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2 — Extract internal cross-file symbol nodes from one input file.
# A symbol is a cross-file internal symbol if:
#   a) it has a definition occurrence in this document AND
#      symbol_has_cross_file_reference maps it to true, OR
#   b) it appears only in the symbols section with an internal package_id
#      (cross-module types from multi-module projects).
# A __file__ fallback node is emitted for documents with no cross-file
# symbol definitions but with references to internal symbols.
# Emits CSV header on first call; subsequent calls must skip the header.
# ---------------------------------------------------------------------------

function extract_internal_symbol_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_CROSS_FILE_FUNCTIONS}"'

        ($index[0].internal_package_ids)              as $internal_pkg_ids |
        ($index[0].symbol_to_file)                    as $sym_to_file       |
        ($index[0].symbol_has_cross_file_reference)   as $is_cross_file     |
        ($index[0].project_root)                      as $project_root      |

        (
            # Source a: cross-file definition occurrences
            [
                .documents[] |
                .relative_path as $file |
                .occurrences[] |
                select((.symbol_roles // 0) % 2 == 1) |
                select(is_valid_scip_symbol(.symbol)) |
                .symbol as $symbol |
                select($sym_to_file[$symbol] == $file) |
                select($is_cross_file[$symbol] == true) |

                ($symbol | split(" ")) as $tokens |
                $tokens[1] as $manager |
                $tokens[2] as $pkg_id  |
                $tokens[3] as $version |
                $tokens[4] as $desc    |

                ($index[0].symbol_to_kind[$symbol]            // null) as $kind     |
                ($index[0].symbol_to_signature_text[$symbol]  // "")   as $sig_text |
                ($index[0].symbol_to_doc_first_line[$symbol]  // "")   as $doc_line |
                code_unit_type_all($kind; $sig_text; $doc_line; $symbol) as $sym_type |

                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    symbol:          short_symbol($symbol),
                    display_name:    display_name_from_descriptor($symbol),
                    scheme:          scheme($symbol),
                    language:        scheme_to_language(scheme($symbol)),
                    kind:            ($kind | if . == null then "" else tostring end),
                    symbol_type:     $sym_type,
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     (if $sym_type == "Interface" or $sym_type == "AbstractClass" or $sym_type == "TypeAlias" then "true" else "false" end),
                    is_test:         (if is_test($file) then "true" else "false" end),
                    project_root:    $project_root,
                    descriptor:      $desc
                }
            ]

            # Source b: symbols-section-only internal types (multi-module projects).
            # These are symbols declared in another module but referenced here, whose
            # definition occurrence never appears in symbol_to_file for this index.
            +
            [
                .documents[] |
                .relative_path as $file |
                .symbols[]? |
                select(.symbol != null) |
                select(is_valid_scip_symbol(.symbol)) |
                .symbol as $symbol |

                ($symbol | split(" ") | .[2]) as $pkg_id |
                select(($internal_pkg_ids | index($pkg_id)) != null) |
                select($sym_to_file[$symbol] == null) |

                ($symbol | split(" ")) as $tokens |
                $tokens[1] as $manager |
                $tokens[3] as $version |
                $tokens[4] as $desc    |

                ($index[0].symbol_to_kind[$symbol]            // null) as $kind     |
                ($index[0].symbol_to_signature_text[$symbol]  // "")   as $sig_text |
                ($index[0].symbol_to_doc_first_line[$symbol]  // "")   as $doc_line |
                code_unit_type_all($kind; $sig_text; $doc_line; $symbol) as $sym_type |

                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    symbol:          short_symbol($symbol),
                    display_name:    display_name_from_descriptor($symbol),
                    scheme:          scheme($symbol),
                    language:        scheme_to_language(scheme($symbol)),
                    kind:            ($kind | if . == null then "" else tostring end),
                    symbol_type:     $sym_type,
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     (if $sym_type == "Interface" or $sym_type == "AbstractClass" or $sym_type == "TypeAlias" then "true" else "false" end),
                    is_test:         (if is_test($file) then "true" else "false" end),
                    project_root:    $project_root,
                    descriptor:      $desc
                }
            ]

            # Source c: __file__ fallback nodes.
            # Emitted for documents that have no cross-file symbol definitions but do
            # reference cross-file or external symbols. Excludes documents whose only
            # references are self-references (same-file, non-cross-file symbols).
            +
            [
                .documents[] |
                .relative_path as $file |

                # Determine if this document defines any cross-file symbols
                ([.occurrences[] |
                  select((.symbol_roles // 0) % 2 == 1) |
                  select(is_valid_scip_symbol(.symbol)) |
                  .symbol as $sym |
                  select($sym_to_file[$sym] == $file) |
                  select($is_cross_file[$sym] == true) |
                  $sym
                 ] | length) as $cross_file_def_count |

                select($cross_file_def_count == 0) |

                # Check whether this document has any outgoing references to cross-file
                # or external symbols (not just self-references to same-file symbols).
                ([.occurrences[] |
                  select((.symbol_roles // 0) % 2 == 0) |
                  select(is_valid_scip_symbol(.symbol)) |
                  .symbol as $sym |
                  ($sym | split(" ") | .[2]) as $p |
                  select(
                      ($is_cross_file[$sym] == true) or
                      (($internal_pkg_ids | index($p)) == null and $p != ".")
                  ) |
                  $sym
                 ] | first) as $has_outgoing_ref |

                select($has_outgoing_ref != null) |

                ([.occurrences[] |
                  select(is_valid_scip_symbol(.symbol)) |
                  .symbol as $s |
                  ($s | split(" ") | .[2]) as $pkg_id |
                  select(($internal_pkg_ids | index($pkg_id)) != null) |
                  $s
                 ] | first) as $first_internal_symbol |

                ($index[0].directory_to_package_tokens[($file | split("/") | .[:-1] | join("/"))]) as $dir_pkg_tokens |

                select($first_internal_symbol != null or $dir_pkg_tokens != null) |

                (if $first_internal_symbol != null then ($first_internal_symbol | split(" "))
                 else $dir_pkg_tokens
                 end) as $tokens |
                $tokens[1] as $manager |
                $tokens[2] as $pkg_id  |
                $tokens[3] as $version |

                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    symbol:          ("__file__ " + $file),
                    display_name:    ($file | split("/") | last),
                    scheme:          $tokens[0],
                    language:        scheme_to_language($tokens[0]),
                    kind:            "",
                    symbol_type:     "File",
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     "false",
                    is_test:         (if is_test($file) then "true" else "false" end),
                    project_root:    $project_root,
                    descriptor:      ""
                }
            ]
        ) |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","language","kind","symbol_type","file","package_id","package_manager","version","module","is_abstract","is_test","project_root","descriptor"]),
        (.[] | [.symbol, .display_name, .scheme, .language, .kind, .symbol_type, .file, .package_id, .package_manager, .version, .module, .is_abstract, .is_test, .project_root, .descriptor])
        | @csv
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 3 — Extract external symbol nodes from one input file (no header).
# External symbols are non-local symbols whose package_id is not in
# internal_package_ids and that appear as reference occurrences. All symbol
# kinds are captured, not just types (unlike the kind-level scripts).
# ---------------------------------------------------------------------------

function extract_external_symbol_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_CROSS_FILE_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |

        [
            .documents[] |
            .occurrences[] |
            select((.symbol_roles // 0) % 2 == 0) |
            select(is_valid_scip_symbol(.symbol)) |
            .symbol as $symbol |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager             |
            $tokens[2] as $pkg_id_from_symbol  |
            $tokens[3] as $version             |
            $tokens[4] as $desc                |

            # Fallback: for symbols with pkg_id ".", derive package from descriptor path
            ($desc | split("/")[0:2] | join("/")) as $pkg_from_desc |
            (if $pkg_id_from_symbol == "." then $pkg_from_desc else $pkg_id_from_symbol end) as $pkg_id |

            select(($internal_pkg_ids | index($pkg_id)) == null) |
            select($pkg_id != ".") |

            ($index[0].symbol_to_kind[$symbol]            // null) as $kind     |
            ($index[0].symbol_to_signature_text[$symbol]  // "")   as $sig_text |
            ($index[0].symbol_to_doc_first_line[$symbol]  // "")   as $doc_line |
            code_unit_type_all($kind; $sig_text; $doc_line; $symbol) as $sym_type |

            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    display_name_from_descriptor($symbol),
                scheme:          scheme($symbol),
                language:        scheme_to_language(scheme($symbol)),
                kind:            ($kind | if . == null then "" else tostring end),
                symbol_type:     $sym_type,
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                descriptor:      $desc
            }
        ] |
        unique_by(.symbol) |
        sort_by(.package_id, .display_name) |
        .[] | [.symbol, .display_name, .scheme, .language, .kind, .symbol_type, .package_id, .package_manager, .version, .module, .descriptor]
        | @csv
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4 — Extract symbol dependency edges from one input file (no header).
# For each document:
#   - Collect cross-file symbol definitions sorted by source line.
#   - For each reference occurrence, attribute it to the nearest cross-file
#     symbol defined above it (line-window). If no cross-file symbol is above
#     the reference, attribute it to the document-level __file__ fallback node
#     when one exists.
# Self-edges are suppressed. Edges are grouped and counted.
# ---------------------------------------------------------------------------

function extract_symbol_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_CROSS_FILE_FUNCTIONS}"'

        ($index[0].internal_package_ids)            as $internal_pkg_ids |
        ($index[0].symbol_to_file)                  as $sym_to_file       |
        ($index[0].symbol_has_cross_file_reference) as $is_cross_file     |

        .documents[] |
        .relative_path as $source_file |

        # Collect cross-file definitions in this document sorted by line.
        # These are the candidate source nodes for edges.
        (
            [.occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(is_valid_scip_symbol(.symbol)) |
             .symbol as $sym |
             select($sym_to_file[$sym] == $source_file) |
             select($is_cross_file[$sym] == true) |
             {symbol: short_symbol($sym), line: .range[0]}
            ] | sort_by(.line) | unique_by(.symbol)
        ) as $cross_file_defs |

        # Check if this document qualifies for a __file__ fallback node.
        # Uses the same condition as extract_internal_symbol_nodes: requires outgoing
        # references to cross-file or external symbols (not just self-references).
        (($cross_file_defs | length) == 0) as $no_cross_file_defs |

        (
            $no_cross_file_defs and
            (
                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 0) |
                 select(is_valid_scip_symbol(.symbol)) |
                 .symbol as $sym |
                 ($sym | split(" ") | .[2]) as $p |
                 select(
                     ($is_cross_file[$sym] == true) or
                     (($internal_pkg_ids | index($p)) == null and $p != ".")
                 ) |
                 $sym
                ] | first) != null
            and
            (
                ([.occurrences[] |
                  select(is_valid_scip_symbol(.symbol)) |
                  .symbol as $s |
                  ($s | split(" ") | .[2]) as $p |
                  select(($internal_pkg_ids | index($p)) != null) |
                  $s
                 ] | first) != null
                or
                $index[0].directory_to_package_tokens[($source_file | split("/") | .[:-1] | join("/"))] != null
            )
        ) as $has_file_fallback |

        # For each reference occurrence, determine source and emit edge info.
        [.occurrences[] |
         select((.symbol_roles // 0) % 2 == 0) |
         select(is_valid_scip_symbol(.symbol)) |
         .range[0] as $occ_line |
         .symbol as $occ_symbol |

         (classify_edge_type($occ_symbol))  as $etype  |
         (edge_target($occ_symbol))         as $target |

         # Nearest cross-file definition at or before this occurrence line
         ([$cross_file_defs[] | select(.line <= $occ_line)] | last) as $owning_def |

         (if $owning_def != null then $owning_def.symbol
          elif $has_file_fallback then ("__file__ " + $source_file)
          else null
          end) as $source_symbol |

         select($source_symbol != null) |
         select($source_symbol != $target) |

         {from: $source_symbol, to: $target, edge_type: $etype}
        ] |

        group_by([.from, .to, .edge_type]) |
        .[] |
        {from: .[0].from, to: .[0].to, edge_type: .[0].edge_type, count: length} |
        [.from, .to, .edge_type, (.count | tostring)] | @csv
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Extract SCIP project metadata from one input file.
# ---------------------------------------------------------------------------

function extract_project_metadata() {
    local input_file="${1}"
    local emit_header="${2}"  # "true" to include header, "false" to skip

    if [ "${emit_header}" = "true" ]; then
        echo 'project_root,tool_name,tool_version'
    fi

    jq -r '
        select(.metadata != null and .metadata.project_root != null) |
        .metadata as $meta |
        (
            if ($meta.project_root | test("file://")) then
                ($meta.project_root | gsub("^file://"; ""))
            else
                $meta.project_root
            end
            | gsub("/$"; "")
        ) as $project_root |
        [$project_root,
         ($meta.tool_info.name    // "unknown"),
         ($meta.tool_info.version // "unknown")
        ] | @csv
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Process a single .scip.json file to temporary per-file CSVs.
# ---------------------------------------------------------------------------

function process_single_index() {
    local input_file="${1}"
    local symbol_nodes_temp="${2}"
    local external_nodes_temp="${3}"
    local edges_temp="${4}"
    local emit_header="${5}"  # "true" to include header on symbol nodes

    echo "convertScipIndexToCsvForNeo4jCrossFileImport: Processing '${input_file}'..."

    local symbol_index_json
    symbol_index_json="$(build_symbol_information_index "${input_file}")"

    local symbol_index_file
    symbol_index_file=$(mktemp)
    # shellcheck disable=SC2064
    trap "rm -f '${symbol_index_file}'" RETURN
    echo "${symbol_index_json}" > "${symbol_index_file}"

    if [ "${emit_header}" = "true" ]; then
        extract_internal_symbol_nodes "${symbol_index_file}" "${input_file}" > "${symbol_nodes_temp}"
    else
        extract_internal_symbol_nodes "${symbol_index_file}" "${input_file}" | tail -n +2 > "${symbol_nodes_temp}"
    fi
    # External nodes: no header (header added during merge)
    extract_external_symbol_nodes "${symbol_index_file}" "${input_file}" > "${external_nodes_temp}"
    # Edges: no header (header added during merge)
    extract_symbol_edges "${symbol_index_file}" "${input_file}" > "${edges_temp}"
}

# ---------------------------------------------------------------------------
# Merge per-file internal symbol node CSVs: deduplicate by symbol.
# Rows with a non-empty file path take priority over rows with an empty one.
# ---------------------------------------------------------------------------

function merge_symbol_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local node_files=()
    while IFS= read -r node_file; do
        node_files+=("${node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_symbol_nodes.csv" | sort)

    # Keep first occurrence per symbol; prefer rows with a non-empty file path.
    cat "${node_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            file = $7
            gsub(/^"/, "", file)
            gsub(/"$/, "", file)
            if (!seen[symbol]) {
                seen[symbol] = $0
                file_seen[symbol] = file
                order[++n] = symbol
            } else if (file_seen[symbol] == "" && file != "") {
                seen[symbol] = $0
                file_seen[symbol] = file
            }
        }
        END { for (i = 1; i <= n; i++) { print seen[order[i]] } }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file external symbol node CSVs: deduplicate by symbol.
# ---------------------------------------------------------------------------

function merge_external_symbol_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local external_node_files=()
    while IFS= read -r ext_file; do
        external_node_files+=("${ext_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_external_nodes.csv" | sort)

    {
        echo '"symbol","display_name","scheme","language","kind","symbol_type","package_id","package_manager","version","module","descriptor"'
        if [ ${#external_node_files[@]} -gt 0 ]; then
            cat "${external_node_files[@]}" | awk -F',' '
                {
                    symbol = $1
                    gsub(/^"/, "", symbol)
                    gsub(/"$/, "", symbol)
                    if (!seen[symbol]++) { print }
                }
            '
        fi
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file edge CSVs: sum reference_count for
# (from, to, edge_type) triples.
# ---------------------------------------------------------------------------

function merge_symbol_edge_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local edge_files=()
    while IFS= read -r edge_file; do
        edge_files+=("${edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_edges.csv" | sort)

    {
        echo '"from","to","edge_type","reference_count"'
        if [ ${#edge_files[@]} -gt 0 ]; then
            cat "${edge_files[@]}" | awk -F',' '
                {
                    from      = $1
                    to        = $2
                    edge_type = $3
                    count     = $4
                    gsub(/"/, "", count)
                    key = from SUBSEP to SUBSEP edge_type
                    counts[key] += count
                    if (!(key in froms)) {
                        froms[key]      = from
                        tos[key]        = to
                        edge_types[key] = edge_type
                        order[NR]       = key
                    }
                }
                END {
                    for (i = 1; i <= NR; i++) {
                        k = order[i]
                        if (k in froms) {
                            print froms[k] "," tos[k] "," edge_types[k] "," counts[k]
                            delete froms[k]
                        }
                    }
                }
            '
        fi
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file project metadata CSVs: deduplicate by project_root.
# ---------------------------------------------------------------------------

function merge_project_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local project_files=()
    while IFS= read -r project_file; do
        project_files+=("${project_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_projects.csv" | sort)

    if [ ${#project_files[@]} -eq 0 ]; then
        echo '"project_root","tool_name","tool_version"' > "${output_file}"
        return
    fi

    cat "${project_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            project_root = $1
            gsub(/^"/, "", project_root)
            gsub(/"$/, "", project_root)
            if (!seen[project_root]++) { print }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "convertScipIndexToCsvForNeo4jCrossFileImport: INDICES_DIRECTORY=${INDICES_DIRECTORY}"
echo "convertScipIndexToCsvForNeo4jCrossFileImport: IMPORT_DIRECTORY=${IMPORT_DIRECTORY}"

validate_prerequisites

mkdir -p "${IMPORT_DIRECTORY}"

tmp_dir=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '${tmp_dir}'" EXIT

first_file=true
while IFS= read -r index_file; do
    file_stem=$(basename "${index_file}" .scip.json | tr -cs 'A-Za-z0-9_-' '_')
    symbol_nodes_temp="${tmp_dir}/${file_stem}_symbol_nodes.csv"
    external_nodes_temp="${tmp_dir}/${file_stem}_external_nodes.csv"
    edges_temp="${tmp_dir}/${file_stem}_edges.csv"
    projects_temp="${tmp_dir}/${file_stem}_projects.csv"

    process_single_index "${index_file}" "${symbol_nodes_temp}" "${external_nodes_temp}" "${edges_temp}" "${first_file}"
    extract_project_metadata "${index_file}" "${first_file}" >> "${projects_temp}"

    first_file=false
done < <(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f | sort)

symbol_nodes_output="${IMPORT_DIRECTORY}/scip_symbol_nodes.csv"
external_nodes_output="${IMPORT_DIRECTORY}/scip_external_symbol_nodes.csv"
edges_output="${IMPORT_DIRECTORY}/scip_symbol_edges.csv"
projects_output="${IMPORT_DIRECTORY}/scip_projects.csv"

echo "convertScipIndexToCsvForNeo4jCrossFileImport: Merging internal symbol node CSVs -> '${symbol_nodes_output}'..."
merge_symbol_node_csvs "${tmp_dir}" "${symbol_nodes_output}"

echo "convertScipIndexToCsvForNeo4jCrossFileImport: Merging external symbol node CSVs -> '${external_nodes_output}'..."
merge_external_symbol_node_csvs "${tmp_dir}" "${external_nodes_output}"

echo "convertScipIndexToCsvForNeo4jCrossFileImport: Merging edge CSVs -> '${edges_output}'..."
merge_symbol_edge_csvs "${tmp_dir}" "${edges_output}"

echo "convertScipIndexToCsvForNeo4jCrossFileImport: Merging project metadata CSVs -> '${projects_output}'..."
merge_project_csvs "${tmp_dir}" "${projects_output}"

symbol_node_count=$(( $(wc -l < "${symbol_nodes_output}") - 1 ))
external_node_count=$(( $(wc -l < "${external_nodes_output}") - 1 ))
edge_count=$(( $(wc -l < "${edges_output}") - 1 ))
project_count=$(( $(wc -l < "${projects_output}") - 1 ))
echo "convertScipIndexToCsvForNeo4jCrossFileImport: Done. ${symbol_node_count} internal symbol node(s), ${external_node_count} external symbol node(s), ${edge_count} edge(s), ${project_count} project(s)."
