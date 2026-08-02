#!/usr/bin/env bash

# Converts SCIP JSON index files (*.scip.json) in INDICES_DIRECTORY to Neo4j import CSVs in IMPORT_DIRECTORY.
# Supports multiple index files: node symbols are deduplicated; edge reference counts are summed.
# Writes scip_type_nodes.csv and scip_type_edges.csv to IMPORT_DIRECTORY.
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
                    display_name:    ($descriptor | gsub("#"; "") | split("/") | last | gsub("`"; "")),
                    scheme:          scheme($symbol),
                    type_name:       $cu_type,
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                    project_root:    $project_root
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
                    symbol:          ("__file__ " + $file),
                    display_name:    ($file | split("/") | last),
                    scheme:          scheme($first_internal_symbol),
                    type_name:       "File",
                    file:            $file,
                    package_id:      $pkg_id,
                    package_manager: $manager,
                    version:         $version,
                    module:          $module_name,
                    is_abstract:     "false",
                    project_root:    $project_root
                }
            ]
        ) |
        unique_by(.symbol) |
        sort_by(.file, .display_name) |

        (["symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract","project_root"]),
        (.[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root])
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
                symbol:          short_symbol($symbol),
                display_name:    ($descriptor | gsub("#"; "") | split("/") | last | gsub("`"; "")),
                scheme:          scheme($symbol),
                type_name:       $cu_type,
                file:            "",
                package_id:      $pkg_id,
                package_manager: $manager,
                version:         $version,
                module:          $module_name,
                is_abstract:     (if $cu_type == "Interface" or $cu_type == "AbstractClass" or $cu_type == "TypeAlias" then "true" else "false" end),
                project_root:    $project_root
            }
        ] |
        unique_by(.symbol) |
        sort_by(.package_id, .display_name) |
        .[] | [.symbol, .display_name, .scheme, .type_name, .file, .package_id, .package_manager, .version, .module, .is_abstract, .project_root]
        | @csv
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
            [$source_symbol, $ref_group.target, ($ref_group.count | tostring)]
            | @csv
        ' "${input_file}"
}

# ---------------------------------------------------------------------------
# Extract SCIP project metadata from one input file (header on first call only)
# Extracts project_root and tool_info from metadata; creates unique project node per index
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Process a single .scip.json file to temporary per-file CSVs
# ---------------------------------------------------------------------------

function process_single_index() {
    local input_file="${1}"
    local nodes_temp="${2}"
    local edges_temp="${3}"
    local emit_header="${4}"  # "true" to include header, "false" to skip

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

    extract_depends_on_edges "${symbol_index_file}" "${input_file}" > "${edges_temp}"
}

# ---------------------------------------------------------------------------
# Merge per-file node CSVs: deduplicate by symbol (first column)
# Input: directory containing *_nodes.csv files (header in first file only)
# ---------------------------------------------------------------------------

function merge_node_csvs() {
    local tmp_dir="${1}"
    local output_file="${2}"

    # Collect node files in sorted order for deterministic output
    local node_files=()
    while IFS= read -r node_file; do
        node_files+=("${node_file}")
    done < <(find "${tmp_dir}" -maxdepth 1 -name "*_nodes.csv" | sort)

    # Concatenate all rows (header already handled per file), then deduplicate by symbol (first column)
    # awk: parse CSV first field (unquoted or quoted), keep first occurrence per symbol
    cat "${node_files[@]}" | awk -F',' '
        NR == 1 { print; next }
        {
            # Extract the symbol field (first CSV column, may be quoted)
            symbol = $1
            gsub(/^"/, "", symbol)
            gsub(/"$/, "", symbol)
            if (!seen[symbol]++) { print }
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
    
    process_single_index "${index_file}" "${nodes_temp}" "${edges_temp}" "${first_file}"
    extract_project_metadata "${index_file}" "${first_file}" >> "${projects_temp}"
    
    first_file=false
done < <(find "${INDICES_DIRECTORY}" -maxdepth 1 -name "*.scip.json" -type f | sort)

nodes_output="${IMPORT_DIRECTORY}/scip_type_nodes.csv"
edges_output="${IMPORT_DIRECTORY}/scip_type_edges.csv"
projects_output="${IMPORT_DIRECTORY}/scip_projects.csv"

echo "convertScipIndexToCsv: Merging node CSVs → '${nodes_output}'..."
merge_node_csvs "${tmp_dir}" "${nodes_output}"

echo "convertScipIndexToCsv: Merging edge CSVs → '${edges_output}'..."
merge_edge_csvs "${tmp_dir}" "${edges_output}"

echo "convertScipIndexToCsv: Merging project metadata CSVs → '${projects_output}'..."
merge_project_csvs "${tmp_dir}" "${projects_output}"

node_count=$(( $(wc -l < "${nodes_output}") - 1 ))
edge_count=$(( $(wc -l < "${edges_output}") - 1 ))
project_count=$(( $(wc -l < "${projects_output}") - 1 ))
echo "convertScipIndexToCsv: Done. ${node_count} node(s), ${edge_count} edge(s), ${project_count} project(s)."
