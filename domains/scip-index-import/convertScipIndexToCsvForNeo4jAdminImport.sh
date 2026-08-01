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
        descriptor(symbol) | endswith("#");

    def is_type_parameter_descriptor(symbol):
        descriptor(symbol) | endswith("]");

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
    jq '{
        symbol_to_file: [
            .documents[] |
            .relative_path as $file |
            .occurrences[] |
            select((.symbol_roles // 0) % 2 == 1) |
            select(.symbol | startswith("local ") | not) |
            { key: .symbol, value: $file }
        ] | from_entries,

        symbol_to_kind: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            { key: .symbol, value: (.kind // null) }
        ] | from_entries,

        symbol_to_signature_text: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            select(.signature_documentation.text != null) |
            { key: .symbol, value: .signature_documentation.text }
        ] | from_entries,

        symbol_to_doc_first_line: [
            .documents[].symbols[]? |
            select(.symbol != null) |
            select((.documentation // []) | length > 0) |
            .documentation[0] as $doc |
            select($doc | startswith("```")) |
            { key: .symbol,
              value: ($doc | split("\n") | .[1] // "") }
        ] | from_entries,

        internal_package_ids: [
            .documents[].occurrences[] |
            select((.symbol_roles // 0) % 2 == 1) |
            select(.symbol | startswith("local ") | not) |
            select((.symbol | split(" ") | length) >= 5) |
            .symbol | split(" ") | .[2]
        ] | unique
    }' "${input_file}"
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

                select(is_type_descriptor($symbol)) |
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
                    name:           ($descriptor | gsub("#"; "") | split("/") | last | gsub("`"; "")),
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

            select(is_type_descriptor($symbol)) |
            select(is_type_parameter_descriptor($symbol) | not) |

            ($symbol | split(" ")) as $tokens |
            $tokens[1] as $manager    |
            $tokens[2] as $pkg_id     |
            $tokens[3] as $version    |
            $tokens[4] as $descriptor |

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
                name:           ($descriptor | gsub("#"; "") | split("/") | last | gsub("`"; "")),
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
        [
            .documents[] |
            .relative_path as $source_file |

                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 1) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 select(is_type_descriptor(.symbol)) |
                 select(is_type_parameter_descriptor(.symbol) | not) |
                 .symbol
                ] as $source_type_symbols |

                [.occurrences[] |
                 select((.symbol_roles // 0) % 2 == 0) |
                 select(.symbol | startswith("local ") | not) |
                 select((.symbol | split(" ") | length) >= 5) |
                 .symbol as $ref_symbol |
                 select(is_type_descriptor($ref_symbol)) |
                 select(is_type_parameter_descriptor($ref_symbol) | not) |
                 $sym_to_file[$ref_symbol] as $target_file |
                 ($ref_symbol | split(" ") | .[2]) as $ref_pkg_id |
                 (($target_file != null and $target_file != $source_file)
                  or ($target_file == null
                        and ($internal_pkg_ids | index($ref_pkg_id)) == null
                        and $ref_pkg_id != ".")) as $is_valid_target |
                 select($is_valid_target) |
                 $ref_symbol
                ] as $valid_ref_symbols |

                ([.occurrences[] |
                  select(.symbol | startswith("local ") | not) |
                  select((.symbol | split(" ") | length) >= 5) |
                  .symbol as $s |
                  ($s | split(" ") | .[2]) as $pkg_id |
                  select(($internal_pkg_ids | index($pkg_id)) != null) |
                  $s
                 ] | first) as $first_internal_symbol |

                (if ($source_type_symbols | length) > 0 then
                     ($source_type_symbols | map(short_symbol(.)))
                 elif ($valid_ref_symbols | length) > 0 and $first_internal_symbol != null then
                     [("__file__ " + $source_file)]
                 else
                     []
                 end) as $source_symbols |

                select(($source_symbols | length) > 0) |
                select(($valid_ref_symbols | length) > 0) |

                $source_symbols[] as $source_symbol |
                $valid_ref_symbols[] as $ref_symbol |
                { source_symbol: $source_symbol, target_symbol: short_symbol($ref_symbol) }
        ] |

        group_by([.source_symbol, .target_symbol]) |
        map(. as $group | {
            source_symbol:   $group[0].source_symbol,
            target_symbol:   $group[0].target_symbol,
            reference_count: ($group | length)
        }) |
        sort_by(.source_symbol, .target_symbol) |

        .[] | [.source_symbol, .target_symbol, "DEPENDS_ON", .reference_count]
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

function process_single_index_admin() {
    local input_file="${1}"
    local nodes_temp="${2}"
    local edges_temp="${3}"
    local links_temp="${4}"
    local emit_header="${5}"  # "true" to include header, "false" to skip

    echo "convertScipIndexToCsvForNeo4jAdminImport: Processing '${input_file}'..."

    local symbol_index_json
    symbol_index_json="$(build_symbol_information_index "${input_file}")"

    # Write JSON to temporary file to avoid "Argument list too long" error with large indices
    local symbol_index_file
    symbol_index_file=$(mktemp)
    # shellcheck disable=SC2064
    trap "rm -f '${symbol_index_file}'" RETURN
    echo "${symbol_index_json}" > "${symbol_index_file}"

    if [ "${emit_header}" = "true" ]; then
        extract_type_nodes_admin "${symbol_index_file}" "${input_file}" > "${nodes_temp}"
    else
        # Skip the header line (first line) from internal nodes
        extract_type_nodes_admin "${symbol_index_file}" "${input_file}" | tail -n +2 > "${nodes_temp}"
    fi
    # External nodes never emit a header
    extract_external_type_nodes_admin "${symbol_index_file}" "${input_file}" >> "${nodes_temp}"

    extract_depends_on_edges_admin "${symbol_index_file}" "${input_file}" > "${edges_temp}"
    extract_type_project_links_admin "${symbol_index_file}" "${input_file}" > "${links_temp}"
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
while IFS= read -r index_file; do
    file_stem=$(basename "${index_file}" .scip.json | tr -cs 'A-Za-z0-9_-' '_')
    nodes_temp="${tmp_dir}/${file_stem}_admin_nodes.csv"
    edges_temp="${tmp_dir}/${file_stem}_admin_edges.csv"
    projects_temp="${tmp_dir}/${file_stem}_admin_projects.csv"
    links_temp="${tmp_dir}/${file_stem}_admin_links.csv"

    process_single_index_admin "${index_file}" "${nodes_temp}" "${edges_temp}" "${links_temp}" "${first_file}"
    extract_project_metadata_admin "${index_file}" "${first_file}" >> "${projects_temp}"

    first_file=false
done < <(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f | sort)

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

node_count=$(( $(wc -l < "${nodes_output}") - 1 ))
project_count=$(( $(wc -l < "${projects_output}") - 1 ))
edge_count=$(( $(wc -l < "${edges_output}") - 1 ))
link_count=$(( $(wc -l < "${links_output}") - 1 ))
echo "convertScipIndexToCsvForNeo4jAdminImport: Done. ${node_count} node(s), ${project_count} project(s), ${edge_count} edge(s), ${link_count} link(s)."
