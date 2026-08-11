#!/usr/bin/env bash

# Converts SCIP JSON index files (*.scip.json) in INDICES_DIRECTORY to neo4j-admin import CSVs in IMPORT_DIRECTORY.
# Produces scip_type_nodes_admin.csv and scip_type_edges_admin.csv for use with "neo4j-admin database import full".
# Unlike convertScipIndexToCsvForNeo4jImport.sh, computes language and isTest in jq and uses neo4j-admin CSV format.
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
CONVERT_SCIP_ADMIN_SCRIPT_DIR=${CONVERT_SCIP_ADMIN_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "convertScipIndexToCsvForNeo4jAdminImport: CONVERT_SCIP_ADMIN_SCRIPT_DIR=${CONVERT_SCIP_ADMIN_SCRIPT_DIR}"

_SCIP_ADMIN_DEBUG=false

function debug_log() {
    [ "${_SCIP_ADMIN_DEBUG}" = "true" ] || return 0
    echo "convertScipIndexToCsvForNeo4jAdminImport: DEBUG: $*" >&2
}

function validate_prerequisites() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: Error: jq is required but not found in PATH." >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: Install jq: brew install jq (macOS) or apt-get install jq (Linux)." >&2
        exit 1
    fi

    if [ ! -d "${INDICES_DIRECTORY}" ]; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: Error: INDICES_DIRECTORY '${INDICES_DIRECTORY}' does not exist." >&2
        exit 1
    fi

    # Fail if any non-.scip.json files are present (e.g. binary .scip files), but allow .sha change-detection files
    local non_json_files
    non_json_files=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -type f ! -name "*.scip.json" ! -name "*.sha" 2>/dev/null | sort || true)
    if [ -n "${non_json_files}" ]; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: Error: Only .scip.json files are supported in INDICES_DIRECTORY '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: Found unsupported files:" >&2
        while IFS= read -r unsupported_file; do
            echo "convertScipIndexToCsvForNeo4jAdminImport:   - ${unsupported_file}" >&2
        done <<< "${non_json_files}"
        echo "convertScipIndexToCsvForNeo4jAdminImport: Remove them or convert binary .scip files using: scip print --json index.scip > index.scip.json" >&2
        exit 1
    fi

    local scip_count
    scip_count=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "${scip_count}" -lt 1 ]; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: Error: No *.scip.json files found in '${INDICES_DIRECTORY}'." >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: Generate SCIP indices outside this pipeline and place .scip.json files there." >&2
        exit 1
    fi

    echo "convertScipIndexToCsvForNeo4jAdminImport: Found ${scip_count} SCIP JSON index file(s) in '${INDICES_DIRECTORY}'."
}

# ---------------------------------------------------------------------------
# jq function definitions: all shared functions + admin-specific extensions
# Defined once in a shell variable and spliced into each jq query.
# ---------------------------------------------------------------------------

JQ_ADMIN_FUNCTIONS='
    def descriptor(symbol):
        symbol | split(" ") | if length >= 5 then .[4] else "" end;

    def is_type_descriptor(symbol):
        descriptor(symbol) | (endswith("#") or (test("^.*#\\[") and endswith("]")));

    def is_base_type_descriptor(symbol):
        descriptor(symbol) | endswith("#");

    def is_type_parameter_descriptor(symbol):
        descriptor(symbol) | endswith("]");

    def normalize_descriptor(symbol):
        descriptor(symbol) | split("#")[0] + "#";

    def normalize_symbol(symbol):
        symbol | split(" ") | 
        if length >= 5 then
            .[0:4] as $prefix | 
            (.[4] | split("#")[0] + "#") as $norm_desc |
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
        (file | contains("/test/"))   or (file | contains("/tests/"))  or
        (file | contains("/spec/"))   or (file | contains("__tests__")) or
        (file | endswith("_test.go")) or (file | contains(".test."))   or
        (file | contains(".spec."))   or (file | contains("\\test\\")) or
        (file | contains("\\tests\\")) or (file | contains("\\spec\\"));
'

# ---------------------------------------------------------------------------
# Pass 1 — Build the symbol information index for one input file
# ---------------------------------------------------------------------------

function build_symbol_information_index() {
    local input_file="${1}"
    local jq_program
    jq_program="${JQ_ADMIN_FUNCTIONS}"'{
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
    }'
    jq "$jq_program" "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2a — Extract internal type nodes (including __file__ nodes) for admin import
# Emits CSV header on first call; subsequent calls must skip the header.
# Node CSV header: symbol:ID(ScipNode),fqn,name,language,scheme,typeName,file,
#                  packageId,packageManager,version,module,isAbstract:boolean,isTest:boolean,:LABEL
# ---------------------------------------------------------------------------

function extract_type_nodes_admin() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |

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
                    id:             short_symbol($symbol),
                    fqn:            short_symbol($symbol),
                    name:           ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
                    language:       scheme_to_language(scheme($symbol)),
                    scheme:         scheme($symbol),
                    typeName:       $cu_type,
                    file:           $file,
                    packageId:      $pkg_id,
                    packageManager: $manager,
                    version:        $version,
                    module:         $module_name,
                    isAbstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                    isTest:         (if is_test($file) then "true" else "false" end),
                    label:          "SCIP;SemanticCodeIndexInternalType"
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

                select(($defined_type_symbols | length) == 0) |
                select(($referenced_type_symbols | length) > 0) |
                select($first_internal_symbol != null) |

                ($first_internal_symbol | split(" ")) as $tokens |
                $tokens[1] as $manager |
                $tokens[2] as $pkg_id |
                $tokens[3] as $version |
                ($pkg_id | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end) as $module_name |

                {
                    id:             ("__file__ " + $file),
                    fqn:            ("__file__ " + $file),
                    name:           ($file | split("/") | last),
                    language:       scheme_to_language(scheme($first_internal_symbol)),
                    scheme:         scheme($first_internal_symbol),
                    typeName:       "File",
                    file:           $file,
                    packageId:      $pkg_id,
                    packageManager: $manager,
                    version:        $version,
                    module:         $module_name,
                    isAbstract:     "false",
                    isTest:         (if is_test($file) then "true" else "false" end),
                    label:          "SCIP;SemanticCodeIndexInternalType"
                }
            ]
        ) |
        unique_by(.id) |
        sort_by(.file, .name) |

        (["symbol:ID(ScipNode)","fqn","name","language","scheme","typeName","file","packageId","packageManager","version","module","isAbstract:boolean","isTest:boolean",":LABEL"]),
        (.[] | [.id, .fqn, .name, .language, .scheme, .typeName, .file, .packageId, .packageManager, .version, .module, .isAbstract, .isTest, .label])
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 2b — Extract external type nodes for admin import (no header)
# External types always have isTest:boolean=false (no file path to evaluate).
# ---------------------------------------------------------------------------

function extract_external_type_nodes_admin() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |
        [
            .documents[] |
            .occurrences[] |

            select((.symbol_roles // 0) % 2 == 0) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |

            .symbol as $symbol |

            select(is_base_type_descriptor($symbol)) |
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
                id:             short_symbol($symbol),
                fqn:            short_symbol($symbol),
                name:           ($descriptor | gsub("#$"; "") | split("/") | last | gsub("`"; "")),
                language:       scheme_to_language(scheme($symbol)),
                scheme:         scheme($symbol),
                typeName:       $cu_type,
                file:           "",
                packageId:      $pkg_id,
                packageManager: $manager,
                version:        $version,
                module:         $module_name,
                isAbstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                isTest:         "false",
                label:          "SCIP;SemanticCodeIndexExternalType"
            }
        ] |
        unique_by(.id) |
        sort_by(.packageId, .name) |
        .[] | [.id, .fqn, .name, .language, .scheme, .typeName, .file, .packageId, .packageManager, .version, .module, .isAbstract, .isTest, .label]
        | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 3 — Extract DEPENDS_ON edges for admin import (no header)
# Edge CSV columns: :START_ID(ScipNode),:END_ID(ScipNode),:TYPE,referenceCount:int
# ---------------------------------------------------------------------------

function extract_depends_on_edges_admin() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'

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

            # Extract sources (role 1) and raw references (role 0)
            [$valid_occurrences[] | select(.role == 1) | .symbol] as $source_type_symbols |
            [$valid_occurrences[] | select(.role == 0) | .symbol] as $all_ref_symbols |

            # Pre-aggregate valid refs by normalized type target, with occurrence count
            (
                $all_ref_symbols |
                group_by(normalize_symbol(.)) |
                map(
                    normalize_symbol(.[0]) as $norm |
                    $sym_to_file[$norm] as $target_file |
                    (.[0] | split(" ") | .[2]) as $ref_pkg_id |
                    select(
                        ($target_file != null and $target_file != $source_file)
                        or ($target_file == null
                              and ($internal_pkg_ids | index($ref_pkg_id)) == null
                              and $ref_pkg_id != ".")
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

            (if ($source_type_symbols | length) > 0 then
                 ($source_type_symbols | map(short_symbol(.)))
             elif ($valid_ref_groups | length) > 0 and $first_internal_symbol != null then
                 [("__file__ " + $source_file)]
             else
                 []
             end) as $source_symbols |

            select(($source_symbols | length) > 0) |
            select(($valid_ref_groups | length) > 0) |

            $source_symbols[] as $source_symbol |
            $valid_ref_groups[] as $ref_group |
            select($source_symbol != $ref_group.target) |
            [$source_symbol, $ref_group.target, "DEPENDS_ON", $ref_group.count]
            | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Process a single .scip.json file to temporary per-file CSVs
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Extract SCIP project metadata from one input file for admin import
# Neo4j admin format: id:ID, property1, property2, :LABEL
# ---------------------------------------------------------------------------

function extract_project_metadata_admin() {
    local input_file="${1}"
    local emit_header="${2}"  # "true" to include header, "false" to skip

    local header='fqn:ID(ScipNode),projectRoot,toolName,toolVersion,:LABEL'
    
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
        (
            # Create a stable FQN from the project root, suitable as node ID
            $project_root | gsub("[^A-Za-z0-9._-]"; "_")
        ) as $project_fqn |
        [
            $project_fqn,
            $project_root,
            ($meta.tool_info.name // "unknown"),
            ($meta.tool_info.version // "unknown"),
            "SCIP;SemanticCodeIndexProject"
        ] | @csv
    ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Pass 4 — Extract BELONGS_TO link rows for admin import (no header)
# Emits one row per internal type (including __file__ nodes): type_id -> project_fqn
# Edge CSV columns: :START_ID(ScipNode),:END_ID(ScipNode),:TYPE
# ---------------------------------------------------------------------------

function extract_type_project_links_admin() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'

        ($index[0].internal_package_ids) as $internal_pkg_ids |

        select(.metadata != null and .metadata.project_root != null) |
        (
            if (.metadata.project_root | test("file://")) then
                (.metadata.project_root | gsub("^file://"; ""))
            else
                .metadata.project_root
            end
            | gsub("/$"; "")
            | gsub("[^A-Za-z0-9._-]"; "_")
        ) as $project_fqn |

        (
            [
                .documents[] |
                .occurrences[] |
                select((.symbol_roles // 0) % 2 == 1) |
                select(.symbol | startswith("local ") | not) |
                select((.symbol | split(" ") | length) >= 5) |
                select(is_type_descriptor(.symbol)) |
                select(is_type_parameter_descriptor(.symbol) | not) |
                short_symbol(.symbol)
            ]
            +
            [
                .documents[] |
                .relative_path as $file |
                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 1) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 select(is_type_descriptor(.symbol)) |
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
                select(($defined_type_symbols | length) == 0) |
                select(($referenced_type_symbols | length) > 0) |
                select($first_internal_symbol != null) |
                ("__file__ " + $file)
            ]
        ) |
        unique[] |
        [., $project_fqn, "BELONGS_TO"] | @csv
    ' "${input_file}"
}

function extract_anonymous_class_nodes_admin() {
    local symbol_index_file="${1}"
    echo "null" | jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'
        [
            ($index[0].anonymous_classes // [])[] |
            {
                id:             .anon_id,
                fqn:            .anon_id,
                name:           (.anon_id | split("$") | .[0] | split("/") | last | gsub("#$"; "")),
                language:       "Java",
                scheme:         "semanticdb",
                typeName:       "AnonymousClass",
                file:           .file,
                packageId:      .pkg_id,
                packageManager: .manager,
                version:        .version,
                module:         ((.pkg_id // "") | if test("^[a-z]+/") then sub("^[a-z]+/"; "") else . end),
                isAbstract:     "false",
                isTest:         (if is_test(.file) then "true" else "false" end),
                label:          "SCIP;SemanticCodeIndexAnonymousType;SemanticCodeIndexInternalType"
            }
        ] |
        unique_by(.id) |
        .[] | [.id, .fqn, .name, .language, .scheme, .typeName, .file, .packageId, .packageManager, .version, .module, .isAbstract, .isTest, .label]
        | @csv
    '
}

function extract_anonymous_class_edges_admin() {
    local symbol_index_file="${1}"
    echo "null" | jq -r --slurpfile index "${symbol_index_file}" "${JQ_ADMIN_FUNCTIONS}"'
        ($index[0].anonymous_classes // [])[] |
        .anon_id as $anon_id |
        .relationships[] |
        select((.is_reference == true) or (.is_implementation == true)) |
        (.symbol | gsub("#.*"; "#")) as $target |
        select($target | test("^semanticdb")) |
        [$anon_id, short_symbol($target), "DEPENDS_ON", 1] | @csv
    '
}

function extract_anonymous_class_project_links_admin() {
    local symbol_index_file="${1}"
    local input_file="${2}"
    echo "null" | jq --slurpfile index "${symbol_index_file}" --slurpfile input_doc "${input_file}" "${JQ_ADMIN_FUNCTIONS}"'
        select(($input_doc[0].metadata // null) != null and ($input_doc[0].metadata.project_root // null) != null) |
        (
            if ($input_doc[0].metadata.project_root | test("file://")) then
                ($input_doc[0].metadata.project_root | gsub("^file://"; ""))
            else
                $input_doc[0].metadata.project_root
            end
            | gsub("/$"; "")
            | gsub("[^A-Za-z0-9._-]"; "_")
        ) as $project_fqn |
        [
            ($index[0].anonymous_classes // [])[] |
            .anon_id |
            [., $project_fqn, "BELONGS_TO"] | @csv
        ][]
    ' -r
}

function process_single_index_admin() {
    local input_file="${1}"
    local nodes_temp="${2}"
    local edges_temp="${3}"
    local links_temp="${4}"
    local emit_header="${5}"  # "true" to include header, "false" to skip

    echo "convertScipIndexToCsvForNeo4jAdminImport: Processing '${input_file}'..."

    local symbol_index_json
    local build_exit_code=0
    symbol_index_json="$(build_symbol_information_index "${input_file}")" || { build_exit_code=$?; }
    
    if [ "${build_exit_code}" -ne 0 ]; then
        echo "ERROR: build_symbol_information_index failed with exit code ${build_exit_code}" >&2
        echo "JSON output from jq: ${symbol_index_json}" >&2
        return "${build_exit_code}"
    fi

    # Write JSON to temporary file to avoid "Argument list too long" error with large indices
    local symbol_index_file
    symbol_index_file=$(mktemp)
    # shellcheck disable=SC2064
    trap "rm -f '${symbol_index_file}'" RETURN
    
    debug_log "Writing symbol index to temporary file: ${symbol_index_file}"
    echo "${symbol_index_json}" > "${symbol_index_file}"
    
    # Verify the index file was written and is not empty
    local index_size
    index_size=$(wc -c < "${symbol_index_file}")
    debug_log "Symbol index file size: ${index_size} bytes"
    if [ "${index_size}" -lt 10 ]; then
        echo "ERROR: Symbol index file is too small (${index_size} bytes)" >&2
        return 3
    fi
    
    if [ "${_SCIP_ADMIN_DEBUG}" = "true" ]; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: DEBUG: First 500 chars of symbol_index_file:" >&2
        head -c 500 "${symbol_index_file}" >&2
        echo "" >&2
    fi
    debug_log "Validating JSON syntax..."
    if ! jq empty "${symbol_index_file}" 2>&1; then
        echo "ERROR: Symbol index file contains invalid JSON" >&2
        echo "Full content of symbol index file:" >&2
        cat "${symbol_index_file}" >&2
        return 3
    fi
    debug_log "JSON syntax is valid"

    debug_log "Extracting internal type nodes (emit_header=${emit_header})..."
    if [ "${emit_header}" = "true" ]; then
        extract_output=$(extract_type_nodes_admin "${symbol_index_file}" "${input_file}" 2>&1)
        extract_exit=$?
        if [ "${extract_exit}" -ne 0 ]; then
            echo "ERROR: extract_type_nodes_admin failed with exit code ${extract_exit}" >&2
            echo "Output from extract_type_nodes_admin:" >&2
            echo "${extract_output}" >&2
            return "${extract_exit}"
        fi
        echo "${extract_output}" > "${nodes_temp}"
    else
        # Skip the header line (first line) from internal nodes
        extract_output=$(extract_type_nodes_admin "${symbol_index_file}" "${input_file}" 2>&1)
        extract_exit=$?
        if [ "${extract_exit}" -ne 0 ]; then
            echo "ERROR: extract_type_nodes_admin failed with exit code ${extract_exit}" >&2
            echo "Output from extract_type_nodes_admin:" >&2
            echo "${extract_output}" >&2
            return "${extract_exit}"
        fi
        echo "${extract_output}" | tail -n +2 > "${nodes_temp}"
    fi
    local nodes_after_internal=$(wc -l < "${nodes_temp}" 2>/dev/null || echo "0")
    debug_log "Internal nodes written: ${nodes_after_internal} lines"
    
    debug_log "Extracting external type nodes..."
    extract_external_type_nodes_admin "${symbol_index_file}" "${input_file}" >> "${nodes_temp}" 2>&1
    local nodes_after_external=$(wc -l < "${nodes_temp}" 2>/dev/null || echo "0")
    debug_log "Total nodes after external: ${nodes_after_external} lines"
    
    debug_log "Extracting anonymous class nodes..."
    extract_anonymous_class_nodes_admin "${symbol_index_file}" >> "${nodes_temp}" 2>&1
    local nodes_final=$(wc -l < "${nodes_temp}" 2>/dev/null || echo "0")
    debug_log "Total nodes after anonymous classes: ${nodes_final} lines"

    debug_log "Extracting DEPENDS_ON edges..."
    extract_depends_on_edges_admin "${symbol_index_file}" "${input_file}" > "${edges_temp}" 2>&1
    local edges_count=$(wc -l < "${edges_temp}" 2>/dev/null || echo "0")
    debug_log "DEPENDS_ON edges written: ${edges_count} lines"
    
    debug_log "Extracting anonymous class edges..."
    extract_anonymous_class_edges_admin "${symbol_index_file}" >> "${edges_temp}" 2>&1
    local edges_final=$(wc -l < "${edges_temp}" 2>/dev/null || echo "0")
    debug_log "Total edges after anonymous classes: ${edges_final} lines"
    
    debug_log "Extracting type project links..."
    extract_type_project_links_admin "${symbol_index_file}" "${input_file}" > "${links_temp}" 2>&1
    local links_count=$(wc -l < "${links_temp}" 2>/dev/null || echo "0")
    debug_log "Project links written: ${links_count} lines"
    
    debug_log "Extracting anonymous class project links..."
    extract_anonymous_class_project_links_admin "${symbol_index_file}" "${input_file}" >> "${links_temp}" 2>&1
    local links_final=$(wc -l < "${links_temp}" 2>/dev/null || echo "0")
    debug_log "Total project links: ${links_final} lines"
    
    debug_log "Successfully completed processing of '${input_file}'"
}

# ---------------------------------------------------------------------------
# Merge per-file node CSVs: deduplicate by symbol (first column)
# Input: directory containing *_admin_nodes.csv files (header in first file only)
# ---------------------------------------------------------------------------

function merge_node_csvs_admin() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local node_files=()
    while IFS= read -r node_file; do
        node_files+=("${node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_admin_nodes.csv" | sort)

    # Concatenate all rows (header already handled per file), then deduplicate by symbol (first column)
    # awk: parse CSV first field (unquoted or quoted), keep first occurrence per symbol
    cat "${node_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            if (!seen[symbol]++) { print }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file edge CSVs: sum referenceCount for (source, target) pairs
# ---------------------------------------------------------------------------

function merge_edge_csvs_admin() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local edge_files=()
    while IFS= read -r edge_file; do
        edge_files+=("${edge_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_admin_edges.csv" | sort)

    {
        # Emit header
        echo ':START_ID(ScipNode),:END_ID(ScipNode),:TYPE,referenceCount:int'

        # Concatenate all edge rows and sum referenceCount by (source, target)
        # Columns: source(1), target(2), type(3), referenceCount(4)
        cat "${edge_files[@]}" | awk -F',' '
            {
                source = $1
                target = $2
                type   = $3
                count  = $4
                gsub(/"/, "", count)
                key = source SUBSEP target
                counts[key] += count
                if (!(key in sources)) {
                    sources[key] = source
                    targets[key] = target
                    types[key]   = type
                    order[NR]    = key
                }
            }
            END {
                for (i = 1; i <= NR; i++) {
                    k = order[i]
                    if (k in sources) {
                        print sources[k] "," targets[k] "," types[k] "," counts[k]
                        delete sources[k]
                    }
                }
            }
        '
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Merge per-file project metadata CSVs: deduplicate by fqn (first column)
# Input: directory containing *_admin_projects.csv files (header in first file only)
# ---------------------------------------------------------------------------

function merge_project_csvs_admin() {
    local tmp_dir="${1}"
    local output_file="${2}"

    # Collect project files in sorted order for deterministic output
    local project_files=()
    while IFS= read -r project_file; do
        project_files+=("${project_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_admin_projects.csv" | sort)

    if [ ${#project_files[@]} -eq 0 ]; then
        # No project metadata found; create empty CSV with admin header
        echo 'fqn:ID(ScipNode),projectRoot,toolName,toolVersion,:LABEL' > "${output_file}"
        return
    fi

    # Concatenate all rows (header already handled per file), then deduplicate by fqn (first column)
    # awk: parse CSV first field (unquoted or quoted), keep first occurrence per fqn
    cat "${project_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the fqn field (first CSV column, may be quoted)
            fqn = $1
            gsub(/^"/, "", fqn)
            gsub(/"$/, "", fqn)
            if (!seen[fqn]++) { print }
        }
    ' > "${output_file}"
}

# ---------------------------------------------------------------------------
# Validate that all edge node references exist in the nodes CSV
# Input: nodes CSV file and edges CSV file
# Returns: 0 if valid, 1 if missing nodes found; prints detailed error message
# ---------------------------------------------------------------------------

function validate_edge_node_references() {
    local nodes_file="${1}"
    local edges_file="${2}"

    # Build set of all valid node IDs from nodes CSV (skip header)
    local valid_nodes_file
    valid_nodes_file=$(mktemp)
    # Extract first column (quoted or unquoted) from nodes CSV and deduplicate
    tail -n +2 "${nodes_file}" | awk -F',' '{
        node_id = $1
        gsub(/^"/, "", node_id)
        gsub(/"$/, "", node_id)
        print node_id
    }' | sort -u > "${valid_nodes_file}"

    # Check edges for missing node references
    local missing_nodes_file
    missing_nodes_file=$(mktemp)
    trap "rm -f '${valid_nodes_file}' '${missing_nodes_file}'" RETURN

    local missing_count=0
    tail -n +2 "${edges_file}" | awk -F',' -v nodes_file="${valid_nodes_file}" '
        BEGIN {
            while ((getline node_line < nodes_file) > 0) {
                valid_nodes[node_line] = 1
            }
            close(nodes_file)
        }
        {
            start_id = $1
            end_id = $2
            gsub(/^"/, "", start_id)
            gsub(/"$/, "", start_id)
            gsub(/^"/, "", end_id)
            gsub(/"$/, "", end_id)
            
            if (!(start_id in valid_nodes)) {
                print "START_NODE: " start_id
            }
            if (!(end_id in valid_nodes)) {
                print "END_NODE: " end_id
            }
        }
    ' | sort -u > "${missing_nodes_file}"

    if [ -s "${missing_nodes_file}" ]; then
        echo "convertScipIndexToCsvForNeo4jAdminImport: ERROR: Found missing node references in edges CSV." >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: These edge references point to nodes that don't exist:" >&2
        head -20 "${missing_nodes_file}" | sed 's/^/  /' >&2
        local total_missing
        total_missing=$(wc -l < "${missing_nodes_file}")
        if [ "${total_missing}" -gt 20 ]; then
            echo "  ... and $(( total_missing - 20 )) more" >&2
        fi
        echo "" >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: This usually means:" >&2
        echo "  - Method/constructor symbols are being referenced as edges but not created as nodes" >&2
        echo "  - Symbol normalization is inconsistent between node and edge extraction" >&2
        echo "" >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: Nodes CSV: ${nodes_file}" >&2
        echo "convertScipIndexToCsvForNeo4jAdminImport: Edges CSV: ${edges_file}" >&2
        return 1
    fi

    return 0
}

# ---------------------------------------------------------------------------
# Merge per-file BELONGS_TO link CSVs: deduplicate by (type_id, project_fqn)
# Input: directory containing *_admin_links.csv files
# ---------------------------------------------------------------------------

function merge_belongs_to_links_admin() {
    local tmp_dir="${1}"
    local output_file="${2}"

    local link_files=()
    while IFS= read -r link_file; do
        link_files+=("${link_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_admin_links.csv" | sort)

    {
        # Emit header for relationship CSV
        echo ':START_ID(ScipNode),:END_ID(ScipNode),:TYPE'

        if [ ${#link_files[@]} -gt 0 ]; then
            cat "${link_files[@]}" | awk -F',' '
                {
                    key = $1 SUBSEP $2
                    if (!seen[key]++) { print }
                }
            '
        fi
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "convertScipIndexToCsvForNeo4jAdminImport: INDICES_DIRECTORY=${INDICES_DIRECTORY}"
echo "convertScipIndexToCsvForNeo4jAdminImport: IMPORT_DIRECTORY=${IMPORT_DIRECTORY}"

validate_prerequisites

mkdir -p "${IMPORT_DIRECTORY}"

tmp_dir=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '${tmp_dir}'" EXIT

first_file=true
debug_log "Starting processing of SCIP index files"
while IFS= read -r index_file; do
    debug_log "Processing index file: ${index_file}"
    file_stem=$(basename "${index_file}" .scip.json | tr -cs 'A-Za-z0-9_-' '_')
    nodes_temp="${tmp_dir}/${file_stem}_admin_nodes.csv"
    edges_temp="${tmp_dir}/${file_stem}_admin_edges.csv"
    projects_temp="${tmp_dir}/${file_stem}_admin_projects.csv"
    links_temp="${tmp_dir}/${file_stem}_admin_links.csv"

    debug_log "Calling process_single_index_admin with file_stem=${file_stem}"
    _exit_code=0
    process_single_index_admin "${index_file}" "${nodes_temp}" "${edges_temp}" "${links_temp}" "${first_file}" || { _exit_code=$?; }
    if [ "${_exit_code}" -ne 0 ]; then
        echo "ERROR: process_single_index_admin failed with exit code ${_exit_code}" >&2
        exit "${_exit_code}"
    fi
    debug_log "process_single_index_admin completed successfully"
    
    debug_log "Calling extract_project_metadata_admin"
    extract_project_metadata_admin "${index_file}" "${first_file}" >> "${projects_temp}"
    debug_log "extract_project_metadata_admin completed"

    first_file=false
done < <(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f | sort)
debug_log "Finished processing all SCIP index files"

nodes_output="${IMPORT_DIRECTORY}/scip_type_nodes_admin.csv"
edges_output="${IMPORT_DIRECTORY}/scip_type_edges_admin.csv"
projects_output="${IMPORT_DIRECTORY}/scip_projects_admin.csv"
links_output="${IMPORT_DIRECTORY}/scip_type_project_links_admin.csv"

echo "convertScipIndexToCsvForNeo4jAdminImport: Merging node CSVs → '${nodes_output}'..."
merge_node_csvs_admin "${tmp_dir}" "${nodes_output}"

echo "convertScipIndexToCsvForNeo4jAdminImport: Merging edge CSVs → '${edges_output}'..."
merge_edge_csvs_admin "${tmp_dir}" "${edges_output}"

echo "convertScipIndexToCsvForNeo4jAdminImport: Merging project metadata CSVs → '${projects_output}'..."
merge_project_csvs_admin "${tmp_dir}" "${projects_output}"

echo "convertScipIndexToCsvForNeo4jAdminImport: Merging BELONGS_TO link CSVs → '${links_output}'..."
merge_belongs_to_links_admin "${tmp_dir}" "${links_output}"

# Validate that all edge references point to existing nodes
echo "convertScipIndexToCsvForNeo4jAdminImport: Validating edge-node references..."
if ! validate_edge_node_references "${nodes_output}" "${edges_output}"; then
    echo "convertScipIndexToCsvForNeo4jAdminImport: Validation FAILED. Cannot proceed with Neo4j import." >&2
    exit 1
fi

node_count=$(( $(wc -l < "${nodes_output}") - 1 ))
project_count=$(( $(wc -l < "${projects_output}") - 1 ))
edge_count=$(( $(wc -l < "${edges_output}") - 1 ))
link_count=$(( $(wc -l < "${links_output}") - 1 ))
echo "convertScipIndexToCsvForNeo4jAdminImport: Done. ${node_count} node(s), ${project_count} project(s), ${edge_count} edge(s), ${link_count} link(s)."
