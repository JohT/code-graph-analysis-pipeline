#!/usr/bin/env bash

# Converts SCIP JSON index files (*.scip.json) in INDICES_DIRECTORY to Neo4j import CSVs in IMPORT_DIRECTORY.
# Supports multiple index files: node symbols are deduplicated; edge reference counts are summed.
# Writes scip_type_nodes.csv, scip_type_edges.csv, scip_function_nodes.csv, scip_function_edges.csv,
# scip_variable_nodes.csv, scip_variable_edges.csv, and scip_projects.csv to IMPORT_DIRECTORY.
# Requires jq.
#
# Multi-module projects: types defined only in the symbols section (no definition occurrence) are extracted
# as internal types using the file path of the document that declares them. When the same symbol appears in
# multiple indices with and without a file path, the row with the non-empty file path wins deduplication so
# that the Cypher import (WHERE file <> '') correctly classifies the type as an internal type.
#
# Pre-computes 'descriptor' property (last space-separated token of SCIP symbol, e.g. "com/example/Foo#").
# Avoids runtime split(symbol, ' ')[-1] in Cypher queries. Works across all languages (Java FQN, Go/Python with backticks)
# because SCIP symbol format "<scheme> <manager> <package> <version> <descriptor>" is standard.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

INDICES_DIRECTORY=${INDICES_DIRECTORY:-"./indices"}
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"./import"}

## Get this "domains/scip-index-import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CONVERT_SCIP_SCRIPT_DIR=${CONVERT_SCIP_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "convertScipIndexToCsvForNeo4jImport: CONVERT_SCIP_SCRIPT_DIR=${CONVERT_SCIP_SCRIPT_DIR}"

function validate_prerequisites() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "convertScipIndexToCsvForNeo4jImport: Error: jq is required but not found in PATH." >&2
        echo "convertScipIndexToCsvForNeo4jImport: Install jq: brew install jq (macOS) or apt-get install jq (Linux)." >&2
        exit 1
    fi

    if [ ! -d "${INDICES_DIRECTORY}" ]; then
        echo "convertScipIndexToCsvForNeo4jImport: Error: INDICES_DIRECTORY '${INDICES_DIRECTORY}' does not exist." >&2
        exit 1
    fi

    # Fail if any non-.scip.json files are present (e.g. binary .scip files), but allow .sha change-detection files
    local non_json_files
    non_json_files=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -type f ! -name "*.scip.json" ! -name "*.sha" 2>/dev/null | sort || true)
    if [ -n "${non_json_files}" ]; then
        echo "convertScipIndexToCsvForNeo4jImport: Error: Only .scip.json files are supported in INDICES_DIRECTORY '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jImport: Found unsupported files:" >&2
        while IFS= read -r unsupported_file; do
            echo "convertScipIndexToCsvForNeo4jImport:   - ${unsupported_file}" >&2
        done <<< "${non_json_files}"
        echo "convertScipIndexToCsvForNeo4jImport: Remove them or convert binary .scip files using: scip print --json index.scip > index.scip.json" >&2
        exit 1
    fi

    local scip_count
    scip_count=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "${scip_count}" -lt 1 ]; then
        echo "convertScipIndexToCsvForNeo4jImport: Error: No *.scip.json files found in '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jImport: Generate SCIP indices outside this pipeline and place .scip.json files there." >&2
        exit 1
    fi

    echo "convertScipIndexToCsvForNeo4jImport: Found ${scip_count} SCIP JSON index file(s) in '${INDICES_DIRECTORY}'."
}

# ---------------------------------------------------------------------------
# Shared jq function definitions (adapted from getting-started-with-scip)
# Defined once in a shell variable and spliced into each jq query.
# ---------------------------------------------------------------------------

JQ_SHARED_FUNCTIONS='
    def descriptor(symbol):
        symbol | split(" ") | if length >= 5 then .[4] else "" end;

    def is_type_descriptor(symbol):
        descriptor(symbol) | (contains("#") and (endswith("]") | not));

    def is_base_type_descriptor(symbol):
        descriptor(symbol) | endswith("#");

    def is_type_parameter_descriptor(symbol):
        descriptor(symbol) | endswith("]");

    # True when the descriptor has "()" with no "#" before it: a module-level
    # function (e.g. lib/nav.ts/fn().) rather than a class method (com/Foo#m().).
    def is_module_level_function_descriptor(sym):
        descriptor(sym) | test("^[^#]*\\(\\)");

    # True when the descriptor is a pure function definition: ends with "()."
    # Distinguishes function declarations from their parameters ("().(x)") and
    # type parameters ("().[T]"), which also match is_module_level_function_descriptor.
    def is_function_definition_descriptor(sym):
        descriptor(sym) | test("\\(\\)\\.$");

    def normalize_descriptor(symbol):
        descriptor(symbol) | split("#")[0] + "#";

    def normalize_symbol(symbol):
        symbol | split(" ") | 
        if length >= 5 then
            .[0:4] as $prefix | 
            .[4] as $descriptor_value |
            (if ($descriptor_value | endswith("#")) then
                $descriptor_value
             else
                 ($descriptor_value | split("#") | .[:-1] | join("#") + "#")
             end) as $norm_desc |
            ($prefix + [$norm_desc]) | join(" ")
        else
            symbol
        end;

    def short_symbol_normalized(s):
        normalize_symbol(s) | split(" ") | if length >= 5 then
            .[2:5] | join(" ")
        else
            .
        end;

    def null_kind_fallback(signature_text; doc_first_line):
        if (signature_text // "" | test("^public final ")) then "Record"
        elif (doc_first_line // "" | test("^abstract class ")) then "AbstractClass"
        elif (doc_first_line // "" | test("^interface ")) then "Interface"
        elif (doc_first_line // "" | test("^class ")) then "Class"
        elif (doc_first_line // "" | test("^enum ")) then "Enum"
        elif (doc_first_line // "" | test("^type ")) then "TypeAlias"
        elif (doc_first_line // "" | test("^\\(method\\)")) then "Method"
        elif (doc_first_line // "" | test("^function ")) then "Function"
        else "Unknown"
        end;

    def code_unit_type(kind; signature_text; doc_first_line):
        if kind == 7 then
            if (signature_text // "" | test("abstract")) then "AbstractClass" else "Class" end
        elif kind == 11 then "Enum"
        elif kind == 17 then "Function"
        elif kind == 21 then "Interface"
        elif kind == 26 then "Method"
        elif kind == 35 then "Package"
        elif kind == 49 then "Struct"
        elif kind == 54 then "TypeAlias"
        elif kind == 66 then "Method"
        elif kind == 67 then "Method"
        elif kind == 80 then "Method"
        elif kind == null then null_kind_fallback(signature_text; doc_first_line)
        else "Unknown"
        end;

    def short_symbol(s):
        s | split(" ") | if length >= 5 then .[2:5] | join(" ") else s end;

    def scheme(s):
        s | split(" ") | .[0];

    # True when descriptor is a file-level variable (ends with . but no # before it).
    # Example: "com/example/myVariable." (matches)
    # Counter-example: "com/example/MyClass#field." (no match, contains #)
    def is_variable_descriptor(sym):
        descriptor(sym) | test("[^#]*\\.$");

    # True when descriptor is a pure variable definition: ends with "." exactly.
    # Distinguishes variable declarations from type parameters like "().[T]".
    def is_base_variable_descriptor(sym):
        descriptor(sym) | endswith(".");

    # True when descriptor is a class/interface field (has # followed by field name and .).
    # Example: "com/example/MyClass#myField." (matches)
    # Counter-example: "com/example/MyClass#Method()." (no match, contains ())
    # Counter-example: "com/example/myVariable." (no match, no #)
    def is_field_descriptor(sym):
        descriptor(sym) | test("#[^#()]+\\.$");

    # True when descriptor is a pure field definition: has # and ends with "." exactly (not ()).
    # Distinguishes field declarations from method declarations or type parameters.
    def is_base_field_descriptor(sym):
        descriptor(sym) | test("#[^#()]+\\.$");

    # True when field is public or protected (filters out private fields).
    # Checks signature documentation or source code markers.
    def is_public_protected_field(sig_text; doc_line):
        ((sig_text // "") | test("(public|protected)")) or
        ((doc_line // "") | test("(public|protected)"));
'

# ---------------------------------------------------------------------------
# Pass 1 — Build the symbol information index for one input file
# ---------------------------------------------------------------------------

function build_symbol_information_index() {
    local input_file="${1}"
    jq "${JQ_SHARED_FUNCTIONS}"'{
        symbol_to_file: [
            .documents[] |
            .relative_path as $file |
            .occurrences[] |
            select((.symbol_roles // 0) % 2 == 1) |
            select(.symbol | startswith("local ") | not) |
            { key: .symbol, value: $file }
        ] | (reduce .[] as $kv ({}; .[$kv.key] = $kv.value)),

        symbol_to_kind: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            { key: .symbol, value: (.kind // null) }
        ] | (reduce .[] as $kv ({}; .[$kv.key] = $kv.value)),

        symbol_to_signature_text: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            select(.signature_documentation.text != null) |
            { key: .symbol, value: .signature_documentation.text }
        ] | (reduce .[] as $kv ({}; .[$kv.key] = $kv.value)),

        symbol_to_doc_first_line: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            select((.documentation // []) | length > 0) |
            .documentation[0] as $doc |
            select($doc | startswith("```")) |
            { key: .symbol,
              value: ($doc | split("\n") | .[1] // "") }
        ] | (reduce .[] as $kv ({}; .[$kv.key] = $kv.value)),

        internal_package_ids: [
            .documents[].occurrences[] |
            select((.symbol_roles // 0) % 2 == 1) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |
            .symbol | split(" ") | .[2]
        ] | unique,

        directory_to_package_tokens: (
            [.documents[] |
             .relative_path as $file |
             ($file | split("/") | .[:-1] | join("/")) as $dir |
             .occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             { key: $dir, value: (.symbol | split(" ") | .[0:4]) }
            ] | reduce .[] as $kv ({}; .[$kv.key] //= $kv.value)
        ),

        project_root: (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ),

        anonymous_classes: [
            ([.documents[].symbols[]? | select(.symbol != null) | select(.kind == 26 or .kind == 66 or .kind == 67 or .kind == 80) | select(.enclosing_symbol != null and (.enclosing_symbol | startswith("local"))) | .enclosing_symbol] | unique) as $local_classes_with_methods |
            .documents[] as $doc |
            $doc.relative_path as $file |
            ($doc.symbols // []) as $all_symbols |
            ([$doc.occurrences[]? | select((.symbol_roles // 0) % 2 == 1) | select(.symbol | startswith("local ") | not) | select((.symbol | split(" ") | length) >= 5) | select(is_base_type_descriptor(.symbol)) | .symbol] | first) as $doc_first_type |
            select($doc_first_type != null) |
            ($doc_first_type | split(" ")) as $enc_tokens |
            ([($all_symbols[] | select(.symbol != null and (.kind == 26 or .kind == 66 or .kind == 67 or .kind == 80)) | select(.enclosing_symbol != null and (.enclosing_symbol | startswith("local"))) | .enclosing_symbol as $enc | select(($local_classes_with_methods | index($enc)) != null))] | group_by(.enclosing_symbol)[] | (first(.[] | select(.relationships != null and (.relationships | length > 0))) // .[0]) as $first_method | [.[] | .relationships // []] as $all_relationships | $first_method.enclosing_symbol as $anon_class_sym | ([$all_symbols[] | select(.symbol == $anon_class_sym) | .enclosing_symbol] | first // $doc_first_type) as $anon_class_enclosing_symbol | ($anon_class_sym | sub("^local"; "") | (tonumber? // 0)) as $min_local_num | ((short_symbol($anon_class_enclosing_symbol) | gsub("[.#.]$"; "")) + "$anonymous" + ($min_local_num | tostring) + "#") as $anon_id | {file: $file, anon_id: $anon_id, enclosing_symbol: $doc_first_type, pkg_id: $enc_tokens[2], version: (if ($enc_tokens | length > 3) then $enc_tokens[3] else "." end), manager: (if ($enc_tokens | length > 1) then $enc_tokens[1] else "." end), min_local_num: $min_local_num, relationships: ($all_relationships | flatten // [])})
        ]
    }' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2a — Extract internal type nodes from one input file
# Emits CSV header on first call; subsequent calls must skip the header.
# ---------------------------------------------------------------------------

function extract_type_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |

        (
            [
                .documents[] |
                .relative_path as $file |
                .occurrences[] |

                select((.symbol_roles // 0) % 2 == 1) |
                select(.symbol | startswith("local ") | not) |
                select((.symbol | split(" ") | length) >= 5) |

                .symbol as $symbol |

                select(is_base_type_descriptor($symbol)) |
                select(is_type_parameter_descriptor($symbol) | not) |

                ($symbol | split(" ")) as $tokens |
                $tokens[1] as $manager    |
                $tokens[2] as $pkg_id     |
                $tokens[3] as $version    |
                $tokens[4] as $descriptor |

                ($index[0].symbol_to_kind[$symbol] // null)          as $kind      |
                ($index[0].symbol_to_signature_text[$symbol] // "")  as $sig_text  |
                ($index[0].symbol_to_doc_first_line[$symbol] // "")  as $doc_line  |
                code_unit_type($kind; $sig_text; $doc_line)        as $cu_type   |

                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    symbol:          short_symbol($symbol),
                    display_name:    ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
                    scheme:          scheme($symbol),
                    type_name:       $cu_type,
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                    project_root:    $project_root,
                    descriptor:      $descriptor
                }
            ]
            +
            [
                .documents[] |
                .relative_path as $file |

                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 1) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 select(is_base_type_descriptor(.symbol)) |
                 select(is_type_parameter_descriptor(.symbol) | not) |
                 .symbol
                ] as $defined_type_symbols |

                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 0) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 select(is_type_descriptor(.symbol)) |
                 select(is_type_parameter_descriptor(.symbol) | not) |
                 .symbol
                ] as $referenced_type_symbols |

                ([.occurrences[] |
                  select(.symbol | startswith("local ") | not) |
                  select((.symbol | split(" ") | length) >= 5) |
                  .symbol as $s |
                  ($s | split(" ") | .[2]) as $pkg_id |
                  select(($internal_pkg_ids | index($pkg_id)) != null) |
                  $s
                 ] | first) as $first_internal_symbol |

                ($index[0].directory_to_package_tokens[($file | split("/") | .[:-1] | join("/"))]) as $dir_pkg_tokens |

                ([.occurrences[] |
                  select((.symbol_roles // 0) % 2 == 0) |
                  select(.symbol | startswith("local ") | not) |
                  select((.symbol | split(" ") | length) >= 5) |
                  select(is_type_descriptor(.symbol)) |
                  select(is_type_parameter_descriptor(.symbol) | not) |
                  .symbol as $s |
                  ($s | split(" ") | .[2]) as $pkg_id |
                  select(($internal_pkg_ids | index($pkg_id)) != null) |
                  $s
                 ] | first) as $first_internal_ref_symbol |

                select(($defined_type_symbols | length) == 0) |
                select(($referenced_type_symbols | length) > 0) |
                select($first_internal_symbol != null or $dir_pkg_tokens != null or $first_internal_ref_symbol != null) |

                (if $first_internal_symbol != null then ($first_internal_symbol | split(" ")) elif $first_internal_ref_symbol != null then ($first_internal_ref_symbol | split(" ")) else $dir_pkg_tokens end) as $tokens |
                $tokens[1] as $manager |
                $tokens[2] as $pkg_id |
                $tokens[3] as $version |
                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    symbol:          ("__file__ " + $file),
                    display_name:    ($file | split("/") | last),
                    scheme:          $tokens[0],
                    type_name:       "File",
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     "false",
                    project_root:    $project_root,
                    descriptor:      ""
                }
            ]
        +
        # Extract internal type nodes from the symbols section.
        # Catches types whose occurrence entries use truncated symbol format (no symbol_roles),
        # which happens for cross-module types in multi-module projects (e.g. a sub-package
        # whose files only have imports as occurrences). Without this path those types would
        # never appear as internal type nodes and would be imported as external types.
        [
            .documents[] |
            .relative_path as $file |
            .symbols[]? |

            select(.symbol != null) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            select(is_base_type_descriptor($symbol)) |
            select(is_type_parameter_descriptor($symbol) | not) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id     |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor |

            select(($internal_pkg_ids | index($pkg_id)) != null) |

            ($index[0].symbol_to_kind[$symbol] // null)          as $kind      |
            ($index[0].symbol_to_signature_text[$symbol] // "")  as $sig_text  |
            ($index[0].symbol_to_doc_first_line[$symbol] // "")  as $doc_line  |
            code_unit_type($kind; $sig_text; $doc_line)        as $cu_type   |

            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       $cu_type,
                file:            $file,
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                project_root:    $project_root,
                descriptor:      $descriptor
            }
        ]
        ) |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root","descriptor"]),
        (.[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor])
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2b — Extract external type nodes from one input file (no header)
# ---------------------------------------------------------------------------

function extract_external_type_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |
        [
            .documents[] |
            .occurrences[] |

            select((.symbol_roles // 0) % 2 == 0) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            select(is_type_descriptor($symbol)) |
            select(is_type_parameter_descriptor($symbol) | not) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id_from_symbol |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor |
            # For external types (where pkg_id is "."), extract package from descriptor
            ($descriptor | split("/")[0:2] | join("/")) as $pkg_from_descriptor |
            (if $pkg_id_from_symbol == "." then $pkg_from_descriptor else $pkg_id_from_symbol end) as $pkg_id |

            select(($internal_pkg_ids | index($pkg_id)) == null) |
            select($pkg_id != ".") |

            ($index[0].symbol_to_kind[$symbol] // null)         as $kind      |
            ($index[0].symbol_to_signature_text[$symbol] // "") as $sig_text  |
            ($index[0].symbol_to_doc_first_line[$symbol] // "") as $doc_line  |
            code_unit_type($kind; $sig_text; $doc_line)       as $cu_type  |

            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       $cu_type,
                file:            "",
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                project_root:    $project_root,
                descriptor:      $descriptor
            }
        ] |
        unique_by(.symbol) |
        sort_by(.package_id, .display_name) |
        .[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor]
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2b — Create external nodes for is_implementation relationship targets
# that do not appear as reference occurrences (non-admin/LOAD CSV variant).
# ---------------------------------------------------------------------------

function extract_relationship_target_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].symbol_to_file) as $sym_to_file |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |

        [
            .documents[] |
            .relative_path as $source_file |
            (.symbols // [])[] |
            select(.symbol != null) |
            .symbol as $source_symbol |
            select(is_base_type_descriptor($source_symbol)) |
            select(is_type_parameter_descriptor($source_symbol) | not) |
            select($sym_to_file[$source_symbol] == $source_file) |
            (.relationships // [])[] |
            select(.is_implementation == true) |
            .symbol |
            select(is_base_type_descriptor(.)) |
            select(is_type_parameter_descriptor(.) | not) |
            select($sym_to_file[.] == null)
        ] |
        unique[] |

        . as $symbol |
        ($symbol | split(" ")) as $tokens |
        $tokens[1] as $manager |
        $tokens[2] as $pkg_id_from_symbol |
        $tokens[3] as $version |
        $tokens[4] as $descriptor |

        ($descriptor | split("/")[0:2] | join("/")) as $pkg_from_descriptor |
        (if $pkg_id_from_symbol == "." then $pkg_from_descriptor else $pkg_id_from_symbol end) as $pkg_id |

        select($pkg_id != ".") |

        ($index[0].symbol_to_kind[$symbol] // null)         as $kind     |
        ($index[0].symbol_to_signature_text[$symbol] // "") as $sig_text |
        ($index[0].symbol_to_doc_first_line[$symbol] // "") as $doc_line |
        code_unit_type($kind; $sig_text; $doc_line)       as $cu_type  |

        ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

        [short_symbol($symbol),
         ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
         scheme($symbol), $cu_type, "", $pkg_id, $manager, $version, $module_name,
         (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
         $project_root, $descriptor] | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 3 — Extract DEPENDS_ON edges from one input file (no header)
# ---------------------------------------------------------------------------

function extract_depends_on_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].symbol_to_file)       as $sym_to_file       |
        ($index[0].internal_package_ids) as $internal_pkg_ids  |

        .documents[] |
        .relative_path as $source_file |

            # Filter and categorize all valid occurrences first (single pass)
            [.occurrences[] |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             select(is_type_descriptor(.symbol)) |
             select(is_type_parameter_descriptor(.symbol) | not) |
             {symbol: .symbol, role: ((.symbol_roles // 0) % 2)}
            ] as $valid_occurrences |

            # Extract sources (role 1, base type descriptors only) and raw references (role 0)
            [$valid_occurrences[] | select(.role == 1) | select(is_base_type_descriptor(.symbol)) | .symbol] as $source_type_symbols |
            [$valid_occurrences[] | select(.role == 0) | .symbol] as $all_ref_symbols |

            # Pre-aggregate valid refs by normalized type target, with occurrence count
            (
                $all_ref_symbols |
                group_by(normalize_symbol(.)) |
                map(
                    normalize_symbol(.[0]) as $norm |
                    $sym_to_file[$norm] as $target_file |
                    # For external types (where pkg_id is "."), extract package from descriptor
                    (.[0] | split(" ") | .[2]) as $pkg_id_from_symbol |
                    (.[0] | split(" ") | .[4] | split("/")[0:2] | join("/")) as $pkg_from_descriptor |
                    (if $pkg_id_from_symbol == "." then $pkg_from_descriptor else $pkg_id_from_symbol end) as $ref_pkg_id |
                    select(
                        ($target_file != null)
                        or ($target_file == null
                              and (
                                  (($internal_pkg_ids | index($ref_pkg_id)) != null)
                                  or (($internal_pkg_ids | index($ref_pkg_id)) == null and $ref_pkg_id != ".")
                              ))
                    ) |
                    { target: ($norm | split(" ") | .[2:5] | join(" ")), count: length }
                )
            ) as $valid_ref_groups |

            # Find first internal symbol for __file__ fallback
            ([$valid_occurrences[] |
              .symbol as $s |
              ($s | split(" ") | .[2]) as $pkg_id |
              select(($internal_pkg_ids | index($pkg_id)) != null) |
              $s
             ] | first) as $first_internal_symbol |

            # Also check for internal type references (role=0 with internal pkg_id)
            ([$valid_occurrences[] |
              select(.role == 0) |
              .symbol as $s |
              ($s | split(" ") | .[2]) as $pkg_id |
              select(($internal_pkg_ids | index($pkg_id)) != null) |
              $s
             ] | first) as $first_internal_ref_symbol |

            ($index[0].directory_to_package_tokens[($source_file | split("/") | .[:-1] | join("/"))] != null) as $has_dir_pkg |

            # Documents that define module-level functions (e.g. TypeScript, Python, Go)
            # own some of the role=0 references; those cannot safely be attributed to any
            # type definition in the same file.  Class methods always include "#" before
            # "()" in their descriptor, so they do not trigger this flag.
            (any(.occurrences[];
                 ((.symbol_roles // 0) % 2 == 1) and
                 (.symbol | startswith("local ") | not) and
                 ((.symbol | split(" ") | length) >= 5) and
                 is_module_level_function_descriptor(.symbol)
                )) as $has_module_level_functions |

            (if ($source_type_symbols | length) > 0 and ($has_module_level_functions | not) then
                 ($source_type_symbols | map(short_symbol(.)))
             elif ($source_type_symbols | length) == 0 and ($valid_ref_groups | length) > 0 and ($first_internal_symbol != null or $first_internal_ref_symbol != null or $has_dir_pkg) then
                 [("__file__ " + $source_file)]
             else
                 []
             end) as $source_symbols |

            select(($source_symbols | length) > 0) |
            select(($valid_ref_groups | length) > 0) |

            $source_symbols[] as $source_symbol |
            $valid_ref_groups[] as $ref_group |
            select($source_symbol != $ref_group.target) |
            [$source_symbol, $ref_group.target, ($ref_group.count | tostring)]
            | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 3b — Extract DEPENDS_ON edges from SCIP symbol relationships (no header)
# Processes documents[].symbols[].relationships[] where is_implementation=true
# to capture inheritance and interface-implementation type dependencies that
# do not appear as explicit occurrences (e.g. transitive interface inheritance).
# ---------------------------------------------------------------------------

function extract_relationship_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].symbol_to_file) as $sym_to_file |

        .documents[] |
        .relative_path as $source_file |

        (.symbols // [])[] |
        select(.symbol != null) |
        .symbol as $source_symbol |
        select(is_base_type_descriptor($source_symbol)) |
        select(is_type_parameter_descriptor($source_symbol) | not) |

        $sym_to_file[$source_symbol] as $source_file_lookup |
        select($source_file_lookup == $source_file) |

        (.relationships // [])[] |
        select(.is_implementation == true) |
        .symbol as $target_symbol |
        select(is_base_type_descriptor($target_symbol)) |
        select(is_type_parameter_descriptor($target_symbol) | not) |

        $sym_to_file[$target_symbol] as $target_file |
        select($target_file != $source_file) |

        (short_symbol($source_symbol)) as $src |
        (short_symbol($target_symbol)) as $tgt |
        select($src != $tgt) |
        [$src, $tgt, "1"] | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4a — Extract internal function nodes from one input file
# Emits CSV header on first call; subsequent calls must skip the header.
# CSV format matches scip_type_nodes.csv for compatible Cypher import queries.
# Only extracts module-level function definitions (kind=17, no "#" before "()").
# ---------------------------------------------------------------------------

function extract_function_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |

        [
            .documents[] |
            .relative_path as $file |
            .symbols[]? |

            select(.symbol != null) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            select(is_module_level_function_descriptor($symbol)) |
            select(is_function_definition_descriptor($symbol)) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id     |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor_val |

            select(($internal_pkg_ids | index($pkg_id)) != null) |

            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor_val | split("/") | last | rtrimstr("().") | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       "Function",
                file:            $file,
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     "false",
                project_root:    $project_root,
                descriptor:      $descriptor_val
            }
        ] |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root","descriptor"]),
        (.[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor])
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4b — Extract function dependency edges from one input file (no header)
# Attributes role=0 occurrences to their owning function using sorted function
# definition lines as body range boundaries (enclosing_range is null in practice).
# Edge types: uses_type (base type ref), calls_function (module-level call),
#             calls_method (method/field access, target normalized to base type).
# ---------------------------------------------------------------------------

function extract_function_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        .documents[] |
        .relative_path as $source_file |

        # Collect module-level function definition occurrences sorted by line.
        # Used as body range boundaries: function i owns occurrences from its
        # start line up to (but not including) function i+1 start line.
        (
            [.occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             select(is_module_level_function_descriptor(.symbol)) |
             select(is_function_definition_descriptor(.symbol)) |
             {symbol: .symbol, line: .range[0]}
            ] | sort_by(.line) | unique_by(.symbol)
        ) as $func_defs |

        select(($func_defs | length) > 0) |

        # For each role=0 occurrence, find the owning function and classify the edge.
        [.occurrences[] |
         select((.symbol_roles // 0) % 2 == 0) |
         select(.symbol | startswith("local ") | not) |
         select((.symbol | split(" ") | length) >= 5) |
         .range[0] as $occ_line |
         .symbol as $occ_symbol |

         # The owning function is the last function defined at or before this line.
         ([$func_defs[] | select(.line <= $occ_line)] | last) as $owning_func |
         select($owning_func != null) |

         (descriptor($occ_symbol)) as $tgt_desc |
         (
           if ($tgt_desc | endswith("#")) then
               {edge_type: "uses_type", target: short_symbol($occ_symbol)}
           elif ($tgt_desc | test("^[^#]*\\(\\)\\.$")) then
               {edge_type: "calls_function", target: short_symbol($occ_symbol)}
           elif ($tgt_desc | contains("#")) then
               {edge_type: "calls_method", target: (normalize_symbol($occ_symbol) | split(" ") | .[2:5] | join(" "))}
           else null
           end
         ) as $edge_info |
         select($edge_info != null) |

         {from: short_symbol($owning_func.symbol), to: $edge_info.target, edge_type: $edge_info.edge_type}
        ] |

        group_by([.from, .to, .edge_type]) |
        .[] |
        select(.[0].from != .[0].to) |
        {from: .[0].from, to: .[0].to, edge_type: .[0].edge_type, count: length} |
        [.from, .to, .edge_type, (.count | tostring)] | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4 — Extract variable nodes (kind 8) from one input file
# Variables are file-level module constants, not local variables.
# Emits CSV header on first call; subsequent calls must skip the header.
# ---------------------------------------------------------------------------

function extract_variable_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |

        [
            .documents[] |
            .relative_path as $file |
            .symbols[]? |

            select(.symbol != null) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            select(.kind == 8) |
            select(is_base_variable_descriptor($symbol)) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id     |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor_val |

            select(($internal_pkg_ids | index($pkg_id)) != null) |

            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor_val | gsub("\\.$"; "") | split("/") | last | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       "Variable",
                file:            $file,
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     "false",
                project_root:    $project_root,
                descriptor:      $descriptor_val
            }
        ] |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root","descriptor"]),
        (.[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor])
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4b — Extract variable initialization edges from one input file (no header)
# Attributes role=0 (reference) occurrences to the containing variable definition.
# Edge types: initializes_with_function, initializes_with_type, initializes_with_variable
# ---------------------------------------------------------------------------

function extract_variable_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        .documents[] |
        .relative_path as $source_file |

        # Collect variable definitions (role=1, kind 8) sorted by line.
        (
            [.occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             select(is_base_variable_descriptor(.symbol)) |
             {symbol: .symbol, line: .range[0]}
            ] | sort_by(.line) | unique_by(.symbol)
        ) as $var_defs |

        select(($var_defs | length) > 0) |

        # For each role=0 occurrence, find owning variable and classify the edge.
        [.occurrences[] |
         select((.symbol_roles // 0) % 2 == 0) |
         select(.symbol | startswith("local ") | not) |
         select((.symbol | split(" ") | length) >= 5) |
         .range[0] as $occ_line |
         .symbol as $occ_symbol |

         # The owning variable is the last variable defined at or before this line, within a 2-line window.
         ([$var_defs[] | select(.line <= $occ_line) | select($occ_line <= (.line + 2))] | last) as $owning_var |
         select($owning_var != null) |

         (descriptor($occ_symbol)) as $tgt_desc |
         (
           if ($tgt_desc | endswith("#")) then
               {edge_type: "initializes_with_type", target: short_symbol($occ_symbol)}
           elif ($tgt_desc | test("^[^#]*\\(\\)\\.$")) then
               {edge_type: "initializes_with_function", target: short_symbol($occ_symbol)}
           elif is_variable_descriptor($occ_symbol) then
               {edge_type: "initializes_with_variable", target: short_symbol($occ_symbol)}
           else null
           end
         ) as $edge_info |
         select($edge_info != null) |

         {from: short_symbol($owning_var.symbol), to: $edge_info.target, edge_type: $edge_info.edge_type}
        ] |

        group_by([.from, .to, .edge_type]) |
        .[] |
        select(.[0].from != .[0].to) |
        {from: .[0].from, to: .[0].to, edge_type: .[0].edge_type, count: length} |
        [.from, .to, .edge_type, (.count | tostring)] | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4c — Extract class/interface field nodes from one input file (with header)
# Emits CSV header on first call; subsequent calls must skip the header.
# Filters to public/protected fields only (excludes private).
# Extracts both kind 61 (TypeScript/Python) and kind 79 (Java) field symbols.
# ---------------------------------------------------------------------------

function extract_field_nodes() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        (
            (.metadata.project_root // "unknown") as $project_root_raw |
            if ($project_root_raw | test("file://")) then
                ($project_root_raw | gsub("^file://"; ""))
            else
                $project_root_raw
            end
            | gsub("/$"; "")
        ) as $project_root |

        [
            .documents[] |
            .relative_path as $file |
            .symbols[]? |

            select(.symbol != null) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            # Extract fields from multiple kinds (language-specific):
            # - kind 61: TypeScript/Python type parameters, test fixtures (if they have field-like descriptors)
            # - kind 79: Java fields, constants, static members
            select(.kind == 61 or .kind == 79) |
            select(is_base_field_descriptor($symbol)) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id     |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor_val |

            select(($internal_pkg_ids | index($pkg_id)) != null) |

            ($index[0].symbol_to_signature_text[$symbol] // "") as $sig_text |
            ($index[0].symbol_to_doc_first_line[$symbol] // "") as $doc_line |

            select(is_public_protected_field($sig_text; $doc_line) or
                   (($sig_text | length) == 0 and ($doc_line | length) == 0)) |

            ($descriptor_val | split("#") | .[0]) as $class_descriptor |
            ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

            {
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor_val | gsub("#"; "/") | gsub("\\.$"; "") | split("/") | last | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       "Field",
                file:            $file,
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     "false",
                project_root:    $project_root,
                descriptor:      $descriptor_val
            }
        ] |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root","descriptor"]),
        (.[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor])
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4d — Extract field initialization edges from one input file (no header)
# Attributes role=0 (reference) occurrences to the containing field definition.
# Edge types: initializes_with_function, initializes_with_type, initializes_with_field
# ---------------------------------------------------------------------------

function extract_field_edges() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'

        .documents[] |
        .relative_path as $source_file |

        # Collect field definitions (role=1, kind 61 or 79) sorted by line.
        (
            [.occurrences[] |
             select((.symbol_roles // 0) % 2 == 1) |
             select(.symbol | startswith("local ") | not) |
             select((.symbol | split(" ") | length) >= 5) |
             select(is_base_field_descriptor(.symbol)) |
             {symbol: .symbol, line: .range[0]}
            ] | sort_by(.line) | unique_by(.symbol)
        ) as $field_defs |

        select(($field_defs | length) > 0) |

        # For each role=0 occurrence, find owning field and classify the edge.
        [.occurrences[] |
         select((.symbol_roles // 0) % 2 == 0) |
         select(.symbol | startswith("local ") | not) |
         select((.symbol | split(" ") | length) >= 5) |
         .range[0] as $occ_line |
         .symbol as $occ_symbol |

         # The owning field is the last field defined at or before this line, within a 2-line window.
         ([$field_defs[] | select(.line <= $occ_line) | select($occ_line <= (.line + 2))] | last) as $owning_field |
         select($owning_field != null) |

         (descriptor($occ_symbol)) as $tgt_desc |
         (
           if ($tgt_desc | endswith("#")) then
               {edge_type: "initializes_with_type", target: short_symbol($occ_symbol)}
           elif ($tgt_desc | test("^[^#]*\\(\\)\\.$")) then
               {edge_type: "initializes_with_function", target: short_symbol($occ_symbol)}
           elif is_field_descriptor($occ_symbol) then
               {edge_type: "initializes_with_field", target: short_symbol($occ_symbol)}
           elif is_variable_descriptor($occ_symbol) then
               {edge_type: "initializes_with_variable", target: short_symbol($occ_symbol)}
           else null
           end
         ) as $edge_info |
         select($edge_info != null) |

         {from: short_symbol($owning_field.symbol), to: $edge_info.target, edge_type: $edge_info.edge_type}
        ] |

        group_by([.from, .to, .edge_type]) |
        .[] |
        select(.[0].from != .[0].to) |
        {from: .[0].from, to: .[0].to, edge_type: .[0].edge_type, count: length} |
        [.from, .to, .edge_type, (.count | tostring)] | @csv
        ' "${input_file}"
}

function extract_project_metadata() {

    local input_file="${1}"
    local emit_header="${2}"  # "true" to include header, "false" to skip

    local header='project_root,tool_name,tool_version'
    
    if [ "$emit_header" = "true" ]; then
        echo "${header}"
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
        [
            $project_root,
            ($meta.tool_info.name // "unknown"),
            ($meta.tool_info.version // "unknown")
        ] | @csv
    ' "${input_file}"
}


function extract_anonymous_class_nodes() {
    local symbol_index_file="${1}"
    echo "null" | jq -r --slurpfile index "${symbol_index_file}" '
        [
            ($index[0].anonymous_classes // [])[] |
            {
                symbol:          .anon_id,
                display_name:    (.anon_id | split("$") | .[0] | split("/") | last | gsub("#$"; "")),
                scheme:          "semanticdb",
                type_name:       "AnonymousClass",
                file:            .file,
                package_id:      .pkg_id,
                package_manager: .manager,
                version:         .version,
                module:          ((.pkg_id // "") | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end),
                is_abstract:     "false",
                project_root:    ($index[0].project_root // ""),
                descriptor:      ""
            }
        ] |
        unique_by(.symbol) |
        .[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root, .descriptor]
        | @csv
    '
}

function extract_anonymous_class_edges() {
    local symbol_index_file="${1}"
    echo "null" | jq -r --slurpfile index "${symbol_index_file}" "${JQ_SHARED_FUNCTIONS}"'
        ($index[0].anonymous_classes // [])[] |
        .anon_id as $anon_id |
        .relationships[] |
        select((.is_reference == true) or (.is_implementation == true)) |
        (.symbol | gsub("#.*"; "#")) as $target |
        select($target | test("^semanticdb")) |
        [$anon_id, short_symbol($target), 1] | @csv
    '
}

# ---------------------------------------------------------------------------
# Process a single .scip.json file to temporary per-file CSVs
# ---------------------------------------------------------------------------

function process_single_index() {
    local input_file="${1}"
    local nodes_temp="${2}"
    local edges_temp="${3}"
    local emit_header="${4}"  # "true" to include header, "false" to skip
    local func_nodes_temp="${5}"
    local func_edges_temp="${6}"
    local var_nodes_temp="${7}"
    local var_edges_temp="${8}"
    local field_nodes_temp="${9}"
    local field_edges_temp="${10}"

    echo "convertScipIndexToCsv: Processing '${input_file}'..."

    local symbol_index_json
    symbol_index_json="$(build_symbol_information_index "${input_file}")"
    
    # Write JSON to temporary file to avoid "Argument list too long" error with large indices
    local symbol_index_file
    symbol_index_file=$(mktemp)
    echo "${symbol_index_json}" > "${symbol_index_file}"
    trap "rm -f '${symbol_index_file}'" RETURN

    if [ "${emit_header}" = "true" ]; then
        extract_type_nodes "${symbol_index_file}" "${input_file}" > "${nodes_temp}"
    else
        # Skip the header line (first line) from internal nodes
        extract_type_nodes "${symbol_index_file}" "${input_file}" | tail -n +2 > "${nodes_temp}"
    fi
    # External nodes never emit a header
    extract_external_type_nodes "${symbol_index_file}" "${input_file}" >> "${nodes_temp}"
    extract_relationship_target_nodes "${symbol_index_file}" "${input_file}" >> "${nodes_temp}"
    
    extract_anonymous_class_nodes "${symbol_index_file}" >> "${nodes_temp}"

    extract_depends_on_edges "${symbol_index_file}" "${input_file}" > "${edges_temp}"
    extract_relationship_edges "${symbol_index_file}" "${input_file}" >> "${edges_temp}"
    extract_anonymous_class_edges "${symbol_index_file}" >> "${edges_temp}"

    if [ "${emit_header}" = "true" ]; then
        extract_function_nodes "${symbol_index_file}" "${input_file}" > "${func_nodes_temp}"
    else
        extract_function_nodes "${symbol_index_file}" "${input_file}" | tail -n +2 > "${func_nodes_temp}"
    fi
    extract_function_edges "${symbol_index_file}" "${input_file}" > "${func_edges_temp}"

    if [ "${emit_header}" = "true" ]; then
        extract_variable_nodes "${symbol_index_file}" "${input_file}" > "${var_nodes_temp}"
    else
        extract_variable_nodes "${symbol_index_file}" "${input_file}" | tail -n +2 > "${var_nodes_temp}"
    fi
    extract_variable_edges "${symbol_index_file}" "${input_file}" > "${var_edges_temp}"

    if [ "${emit_header}" = "true" ]; then
        extract_field_nodes "${symbol_index_file}" "${input_file}" > "${field_nodes_temp}"
    else
        extract_field_nodes "${symbol_index_file}" "${input_file}" | tail -n +2 > "${field_nodes_temp}"
    fi
    extract_field_edges "${symbol_index_file}" "${input_file}" > "${field_edges_temp}"
}


# ---------------------------------------------------------------------------
# Merge per-file node CSVs: deduplicate by symbol (first column)
# Input: directory containing *_nodes.csv files (header in first file only)
# ---------------------------------------------------------------------------

function merge_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local node_files=()
    while IFS= read -r node_file; do
        node_files+=("${node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_nodes.csv" | sort)

    # Concatenate all rows (header already handled per file), then deduplicate by symbol (first column).
    # Rows with a non-empty file path (internal type sources) take priority over rows with an empty
    # file path (external type sources) for the same symbol. In a multi-module project, a type is
    # referenced with no file path in earlier-sorting modules that consume it, but defined with a
    # correct file path in the later-sorting module that owns it. Preferring non-empty file ensures
    # the Cypher import treats the type as an internal type (file <> '' condition).
    cat "${node_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the symbol field (first CSV column, may be quoted)
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            file = $5
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
        END {
            for (i = 1; i <= n; i++) { print seen[order[i]] }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file edge CSVs: sum reference_count for (source, target) pairs
# ---------------------------------------------------------------------------

function merge_edge_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local edge_files=()
    while IFS= read -r edge_file; do
        edge_files+=("${edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_edges.csv" | sort)

    {
        # Emit header
        echo '"source_symbol","target_symbol","reference_count"'

        # Concatenate all edge rows and sum reference_count by (source_symbol, target_symbol)
        cat "${edge_files[@]}" | awk -F',' '
            {
                # First two columns are the key; third is reference_count (unquoted integer)
                source = $1
                target = $2
                count  = $3
                gsub(/"/, "", count)
                key = source SUBSEP target
                counts[key] += count
                if (!(key in sources)) {
                    sources[key] = source
                    targets[key] = target
                    order[NR]    = key
                }
            }
            END {
                for (i = 1; i <= NR; i++) {
                    k = order[i]
                    if (k in sources) {
                        print sources[k] "," targets[k] "," counts[k]
                        delete sources[k]
                    }
                }
            }
        '
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file project metadata CSVs: deduplicate by project_root
# Input: directory containing *_projects.csv files (header in first file only)
# ---------------------------------------------------------------------------

function merge_project_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    # Collect project files in sorted order for deterministic output
    local project_files=()
    while IFS= read -r project_file; do
        project_files+=("${project_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_projects.csv" | sort)

    if [ ${#project_files[@]} -eq 0 ]; then
        # No project metadata found; create empty CSV with header
        echo '"project_root","tool_name","tool_version"' > "${output_file}"
        return
    fi

    # Concatenate all rows (header already handled per file), then deduplicate by project_root (first column)
    # awk: parse CSV first field (unquoted or quoted), keep first occurrence per project_root
    cat "${project_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the project_root field (first CSV column, may be quoted)
            project_root = $1
            gsub(/^"/, "", project_root)
            gsub(/"$/, "", project_root)
            if (!seen[project_root]++) { print }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file function node CSVs: deduplicate by symbol (first column).
# Rows with a non-empty file path take priority over rows with an empty one.
# ---------------------------------------------------------------------------

function merge_function_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local func_node_files=()
    while IFS= read -r func_node_file; do
        func_node_files+=("${func_node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_func_nodes.tmp" | sort)

    if [ ${#func_node_files[@]} -eq 0 ]; then
        echo '"symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root","descriptor"' > "${output_file}"
        return
    fi

    cat "${func_node_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            file = $5
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
        END {
            for (i = 1; i <= n; i++) { print seen[order[i]] }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file function edge CSVs: sum reference_count for
# (source_symbol, target_symbol, edge_type) triples
# ---------------------------------------------------------------------------

function merge_function_edge_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local func_edge_files=()
    while IFS= read -r func_edge_file; do
        func_edge_files+=("${func_edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_func_edges.tmp" | sort)

    {
        echo '"source_symbol","target_symbol","edge_type","reference_count"'
        if [ ${#func_edge_files[@]} -gt 0 ]; then
            cat "${func_edge_files[@]}" | awk -F',' '
                {
                    source    = $1
                    target    = $2
                    edge_type = $3
                    count     = $4
                    gsub(/"/, "", count)
                    key = source SUBSEP target SUBSEP edge_type
                    counts[key] += count
                    if (!(key in sources)) {
                        sources[key]    = source
                        targets[key]    = target
                        edge_types[key] = edge_type
                        order[NR]       = key
                    }
                }
                END {
                    for (i = 1; i <= NR; i++) {
                        k = order[i]
                        if (k in sources) {
                            print sources[k] "," targets[k] "," edge_types[k] "," counts[k]
                            delete sources[k]
                        }
                    }
                }
            '
        fi
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file variable node CSVs: deduplicate by symbol (first column).
# Rows with a non-empty file path take priority over rows with an empty one.
# ---------------------------------------------------------------------------

function merge_variable_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local var_node_files=()
    while IFS= read -r var_node_file; do
        var_node_files+=("${var_node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_var_nodes.tmp" | sort)

    cat "${var_node_files[@]}" 2>/dev/null | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the symbol field (first CSV column, may be quoted)
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            file = $5
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
        END {
            for (i = 1; i <= n; i++) { print seen[order[i]] }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file variable edge CSVs: sum reference_count for
# (source_symbol, target_symbol, edge_type) triples
# ---------------------------------------------------------------------------

function merge_variable_edge_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local var_edge_files=()
    while IFS= read -r var_edge_file; do
        var_edge_files+=("${var_edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_var_edges.tmp" | sort)

    {
        echo '"source_symbol","target_symbol","edge_type","reference_count"'
        if [ ${#var_edge_files[@]} -gt 0 ]; then
            cat "${var_edge_files[@]}" | awk -F',' '
                {
                    source    = $1
                    target    = $2
                    edge_type = $3
                    count     = $4
                    gsub(/"/, "", count)
                    key = source SUBSEP target SUBSEP edge_type
                    counts[key] += count
                    if (!(key in sources)) {
                        sources[key]    = source
                        targets[key]    = target
                        edge_types[key] = edge_type
                        order[NR]       = key
                    }
                }
                END {
                    for (i = 1; i <= NR; i++) {
                        k = order[i]
                        if (k in sources) {
                            print sources[k] "," targets[k] "," edge_types[k] "," counts[k]
                            delete sources[k]
                        }
                    }
                }
            '
        fi
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file field node CSVs: deduplicate by symbol (first column)
# Input: directory containing *_field_nodes.tmp files (header in first file only)
# ---------------------------------------------------------------------------

function merge_field_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local field_node_files=()
    while IFS= read -r field_node_file; do
        field_node_files+=("${field_node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_field_nodes.tmp" | sort)

    cat "${field_node_files[@]}" 2>/dev/null | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the symbol field (first CSV column, may be quoted)
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            file = $5
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
        END {
            for (i = 1; i <= n; i++) { print seen[order[i]] }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file field edge CSVs: sum reference_count for
# (source_symbol, target_symbol, edge_type) triples
# ---------------------------------------------------------------------------

function merge_field_edge_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local field_edge_files=()
    while IFS= read -r field_edge_file; do
        field_edge_files+=("${field_edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_field_edges.tmp" | sort)

    {
        echo '"source_symbol","target_symbol","edge_type","reference_count"'
        if [ ${#field_edge_files[@]} -gt 0 ]; then
            cat "${field_edge_files[@]}" | awk -F',' '
                {
                    source    = $1
                    target    = $2
                    edge_type = $3
                    count     = $4
                    gsub(/"/, "", count)
                    key = source SUBSEP target SUBSEP edge_type
                    counts[key] += count
                    if (!(key in sources)) {
                        sources[key]    = source
                        targets[key]    = target
                        edge_types[key] = edge_type
                        order[NR]       = key
                    }
                }
                END {
                    for (i = 1; i <= NR; i++) {
                        k = order[i]
                        if (k in sources) {
                            print sources[k] "," targets[k] "," edge_types[k] "," counts[k]
                            delete sources[k]
                        }
                    }
                }
            '
        fi
    } > "${output_file}"
}


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "convertScipIndexToCsv: INDICES_DIRECTORY=${INDICES_DIRECTORY}"
echo "convertScipIndexToCsv: IMPORT_DIRECTORY=${IMPORT_DIRECTORY}"

validate_prerequisites

mkdir -p "${IMPORT_DIRECTORY}"

tmp_dir=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '${tmp_dir}'" EXIT

first_file=true
while IFS= read -r index_file; do
    file_stem=$(basename "${index_file}" .scip.json | tr -cs 'A-Za-z0-9_-' '_')
    nodes_temp="${tmp_dir}/${file_stem}_nodes.csv"
    edges_temp="${tmp_dir}/${file_stem}_edges.csv"
    projects_temp="${tmp_dir}/${file_stem}_projects.csv"
    # Use .tmp extension to avoid glob collision with *_nodes.csv and *_edges.csv patterns
    func_nodes_temp="${tmp_dir}/${file_stem}_func_nodes.tmp"
    func_edges_temp="${tmp_dir}/${file_stem}_func_edges.tmp"
    var_nodes_temp="${tmp_dir}/${file_stem}_var_nodes.tmp"
    var_edges_temp="${tmp_dir}/${file_stem}_var_edges.tmp"
    field_nodes_temp="${tmp_dir}/${file_stem}_field_nodes.tmp"
    field_edges_temp="${tmp_dir}/${file_stem}_field_edges.tmp"
    
    process_single_index "${index_file}" "${nodes_temp}" "${edges_temp}" "${first_file}" "${func_nodes_temp}" "${func_edges_temp}" "${var_nodes_temp}" "${var_edges_temp}" "${field_nodes_temp}" "${field_edges_temp}"
    extract_project_metadata "${index_file}" "${first_file}" >> "${projects_temp}"
    
    first_file=false
done < <(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f | sort)

nodes_output="${IMPORT_DIRECTORY}/scip_type_nodes.csv"
edges_output="${IMPORT_DIRECTORY}/scip_type_edges.csv"
projects_output="${IMPORT_DIRECTORY}/scip_projects.csv"
func_nodes_output="${IMPORT_DIRECTORY}/scip_function_nodes.csv"
func_edges_output="${IMPORT_DIRECTORY}/scip_function_edges.csv"
var_nodes_output="${IMPORT_DIRECTORY}/scip_variable_nodes.csv"
var_edges_output="${IMPORT_DIRECTORY}/scip_variable_edges.csv"
field_nodes_output="${IMPORT_DIRECTORY}/scip_field_nodes.csv"
field_edges_output="${IMPORT_DIRECTORY}/scip_field_edges.csv"

echo "convertScipIndexToCsv: Merging node CSVs → '${nodes_output}'..."
merge_node_csvs "${tmp_dir}" "${nodes_output}"

echo "convertScipIndexToCsv: Merging edge CSVs → '${edges_output}'..."
merge_edge_csvs "${tmp_dir}" "${edges_output}"

echo "convertScipIndexToCsv: Merging project metadata CSVs → '${projects_output}'..."
merge_project_csvs "${tmp_dir}" "${projects_output}"

echo "convertScipIndexToCsv: Merging function node CSVs → '${func_nodes_output}'..."
merge_function_node_csvs "${tmp_dir}" "${func_nodes_output}"

echo "convertScipIndexToCsv: Merging function edge CSVs → '${func_edges_output}'..."
merge_function_edge_csvs "${tmp_dir}" "${func_edges_output}"

echo "convertScipIndexToCsv: Merging variable node CSVs → '${var_nodes_output}'..."
merge_variable_node_csvs "${tmp_dir}" "${var_nodes_output}"

echo "convertScipIndexToCsv: Merging variable edge CSVs → '${var_edges_output}'..."
merge_variable_edge_csvs "${tmp_dir}" "${var_edges_output}"

echo "convertScipIndexToCsv: Merging field node CSVs → '${field_nodes_output}'..."
merge_field_node_csvs "${tmp_dir}" "${field_nodes_output}"

echo "convertScipIndexToCsv: Merging field edge CSVs → '${field_edges_output}'..."
merge_field_edge_csvs "${tmp_dir}" "${field_edges_output}"

node_count=$(( $(wc -l < "${nodes_output}") - 1 ))
edge_count=$(( $(wc -l < "${edges_output}") - 1 ))
project_count=$(( $(wc -l < "${projects_output}") - 1 ))
func_node_count=$(( $(wc -l < "${func_nodes_output}") - 1 ))
func_edge_count=$(( $(wc -l < "${func_edges_output}") - 1 ))
var_node_count=$(( $(wc -l < "${var_nodes_output}") - 1 ))
var_edge_count=$(( $(wc -l < "${var_edges_output}") - 1 ))
field_node_count=$(( $(wc -l < "${field_nodes_output}") - 1 ))
field_edge_count=$(( $(wc -l < "${field_edges_output}") - 1 ))
echo "convertScipIndexToCsv: Done. ${node_count} type node(s), ${edge_count} type edge(s), ${project_count} project(s), ${func_node_count} function node(s), ${func_edge_count} function edge(s), ${var_node_count} variable node(s), ${var_edge_count} variable edge(s), ${field_node_count} field node(s), ${field_edge_count} field edge(s)."

