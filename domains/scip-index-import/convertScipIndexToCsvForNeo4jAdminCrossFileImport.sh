#!/usr/bin/env bash

# Converts SCIP JSON index files (*.scip.json) to neo4j-admin import CSVs in IMPORT_DIRECTORY.
# Thin wrapper around convertScipIndexToCsvForNeo4jCrossFileImport.sh:
# 1. Calls that script to produce canonical CSVs (scip_symbol_nodes.csv, etc.).
# 2. Transforms column headers and adds :LABEL/:TYPE columns via awk for neo4j-admin import format.
# Produces: scip_symbol_nodes_admin.csv, scip_external_symbol_nodes_admin.csv,
#           scip_symbol_edges_admin.csv, scip_projects_admin.csv,
#           scip_symbol_project_links_admin.csv.
# Requires convertScipIndexToCsvForNeo4jCrossFileImport.sh, jq.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

INDICES_DIRECTORY=${INDICES_DIRECTORY:-"./indices"}
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"./import"}

## Get this "domains/scip-index-import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CONVERT_SCIP_ADMIN_CROSS_FILE_SCRIPT_DIR=${CONVERT_SCIP_ADMIN_CROSS_FILE_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: CONVERT_SCIP_ADMIN_CROSS_FILE_SCRIPT_DIR=${CONVERT_SCIP_ADMIN_CROSS_FILE_SCRIPT_DIR}"

readonly CROSS_FILE_SCRIPT="${CONVERT_SCIP_ADMIN_CROSS_FILE_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jCrossFileImport.sh"

function validate_prerequisites() {
    if [ ! -f "${CROSS_FILE_SCRIPT}" ]; then
        echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Error: Required script not found: ${CROSS_FILE_SCRIPT}" >&2
        exit 1
    fi
}

# ---------------------------------------------------------------------------
# transform_symbol_nodes_to_admin
# Reads scip_symbol_nodes.csv (canonical LOAD CSV format) and writes
# scip_symbol_nodes_admin.csv (neo4j-admin format).
#
# Column changes:
#   symbol        -> symbol:ID(ScipNode)
#   is_abstract   -> is_abstract:boolean
#   is_test       -> is_test:boolean
#   (new column)  -> :LABEL  (derived from symbol_type column)
#
# :LABEL mapping (labels are semicolon-separated for neo4j-admin multi-label):
#   Function/Method                           -> SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexFunction
#   Class/Interface/AbstractClass/Record/     -> SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexInternalType
#     Struct/Enum/File/AnonymousClass
#   TypeAlias                                 -> SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexTypeAlias
#   Variable                                  -> SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexVariable
#   Field                                     -> SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexField
#   Package/Unknown/(anything else)           -> SCIP;SemanticCodeIndexInternalSymbol
# ---------------------------------------------------------------------------

function transform_symbol_nodes_to_admin() {
    local input_file="${1}"
    local output_file="${2}"

    awk -F',' 'BEGIN { OFS="," }
    NR == 1 {
        # Rename headers and append :LABEL
        # Input:  symbol,display_name,scheme,language,kind,symbol_type,file,...,is_abstract,is_test,project_root,descriptor
        # Output: symbol:ID(ScipNode),display_name,scheme,language,kind:int,symbol_type,file,...,is_abstract:boolean,is_test:boolean,project_root,descriptor,:LABEL
        gsub(/^"?symbol"?/, "\"symbol:ID(ScipNode)\"")
        gsub(/^"?is_abstract"?/, "\"is_abstract:boolean\"")  # handled below by column index
        sub(/"symbol"/, "\"symbol:ID(ScipNode)\"")
        # Rewrite specific column headers
        for (i = 1; i <= NF; i++) {
            col = $i
            gsub(/^"/, "", col)
            gsub(/"$/, "", col)
            if      (col == "symbol")      $i = "\"symbol:ID(ScipNode)\""
            else if (col == "kind")        $i = "\"kind:int\""
            else if (col == "is_abstract") $i = "\"is_abstract:boolean\""
            else if (col == "is_test")     $i = "\"is_test:boolean\""
        }
        print $0 ",\":LABEL\""
        next
    }
    {
        # Extract symbol_type (column 6, 1-based)
        sym_type = $6
        gsub(/^"/, "", sym_type)
        gsub(/"$/, "", sym_type)

        if (sym_type == "Function" || sym_type == "Method") {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexFunction\""
        } else if (sym_type == "Class" || sym_type == "Interface" || sym_type == "AbstractClass" ||
                   sym_type == "Record" || sym_type == "Struct"    || sym_type == "Enum"         ||
                   sym_type == "File"   || sym_type == "AnonymousClass") {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexInternalType\""
        } else if (sym_type == "TypeAlias") {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexTypeAlias\""
        } else if (sym_type == "Variable") {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexVariable\""
        } else if (sym_type == "Field") {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexField\""
        } else {
            label = "\"SCIP;SemanticCodeIndexInternalSymbol\""
        }

        print $0 "," label
    }' "${input_file}" > "${output_file}"
}

# ---------------------------------------------------------------------------
# transform_external_symbol_nodes_to_admin
# Reads scip_external_symbol_nodes.csv and writes
# scip_external_symbol_nodes_admin.csv.
#
# :LABEL mapping (under SemanticCodeIndexExternalSymbol):
#   Function/Method                           -> SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexFunction
#   Class/Interface/AbstractClass/Record/     -> SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexExternalType
#     Struct/Enum/TypeAlias/Unknown
#   Variable                                  -> SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexVariable
#   Field                                     -> SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexField
#   Package/(anything else)                   -> SCIP;SemanticCodeIndexExternalSymbol
# ---------------------------------------------------------------------------

function transform_external_symbol_nodes_to_admin() {
    local input_file="${1}"
    local output_file="${2}"

    awk -F',' 'BEGIN { OFS="," }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            col = $i
            gsub(/^"/, "", col)
            gsub(/"$/, "", col)
            if (col == "symbol") $i = "\"symbol:ID(ScipNode)\""
            if (col == "kind")   $i = "\"kind:int\""
        }
        print $0 ",\":LABEL\""
        next
    }
    {
        sym_type = $6
        gsub(/^"/, "", sym_type)
        gsub(/"$/, "", sym_type)

        if (sym_type == "Function" || sym_type == "Method") {
            label = "\"SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexFunction\""
        } else if (sym_type == "Class" || sym_type == "Interface" || sym_type == "AbstractClass" ||
                   sym_type == "Record" || sym_type == "Struct"    || sym_type == "Enum"         ||
                   sym_type == "TypeAlias" || sym_type == "Unknown") {
            label = "\"SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexExternalType\""
        } else if (sym_type == "Variable") {
            label = "\"SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexVariable\""
        } else if (sym_type == "Field") {
            label = "\"SCIP;SemanticCodeIndexExternalSymbol;SemanticCodeIndexField\""
        } else {
            label = "\"SCIP;SemanticCodeIndexExternalSymbol\""
        }

        print $0 "," label
    }' "${input_file}" > "${output_file}"
}

# ---------------------------------------------------------------------------
# transform_edges_to_admin
# Reads scip_symbol_edges.csv and writes scip_symbol_edges_admin.csv.
# Column changes:
#   from           -> :START_ID(ScipNode)
#   to             -> :END_ID(ScipNode)
#   reference_count -> reference_count:int
#   (new column)   -> :TYPE = DEPENDS_ON (relationship type)
#   edge_type      -> edge_type (kept as property)
# ---------------------------------------------------------------------------

function transform_edges_to_admin() {
    local input_file="${1}"
    local output_file="${2}"

    awk -F',' 'BEGIN { OFS="," }
    NR == 1 {
        # from,to,edge_type,reference_count
        # -> :START_ID(ScipNode),:END_ID(ScipNode),:TYPE,reference_count:int,edge_type
        print "\":START_ID(ScipNode)\",\":END_ID(ScipNode)\",\":TYPE\",\"reference_count:int\",\"edge_type\""
        next
    }
    {
        from           = $1
        to             = $2
        edge_type      = $3
        reference_count = $4
        print from "," to ",\"DEPENDS_ON\"," reference_count "," edge_type
    }' "${input_file}" > "${output_file}"
}

# ---------------------------------------------------------------------------
# transform_projects_to_admin
# Reads scip_projects.csv and writes scip_projects_admin.csv.
# Column changes:
#   project_root -> fqn:ID(ScipNode)  (fqn is project_root with special chars replaced)
#   tool_name    -> toolName
#   tool_version -> toolVersion
#   (new column) -> :LABEL = SCIP;SemanticCodeIndexProject
#
# The fqn is derived from project_root by replacing non-alphanumeric characters
# with underscores (same logic as the kind-level admin script).
# ---------------------------------------------------------------------------

function transform_projects_to_admin() {
    local input_file="${1}"
    local output_file="${2}"

    awk -F',' 'BEGIN { OFS="," }
    NR == 1 {
        print "\"fqn:ID(ScipNode)\",\"projectRoot\",\"toolName\",\"toolVersion\",\":LABEL\""
        next
    }
    {
        project_root = $1
        tool_name    = $2
        tool_version = $3
        gsub(/^"/, "", project_root)
        gsub(/"$/, "", project_root)

        # Derive fqn by replacing non-alphanumeric characters with underscores
        fqn = project_root
        gsub(/[^A-Za-z0-9._-]/, "_", fqn)

        print "\"" fqn "\"," "\"" project_root "\"," tool_name "," tool_version ",\"SCIP;SemanticCodeIndexProject\""
    }' "${input_file}" > "${output_file}"
}

# ---------------------------------------------------------------------------
# produce_project_links_admin
# Reads scip_symbol_nodes.csv (canonical format) and writes
# scip_symbol_project_links_admin.csv with BELONGS_TO relationships.
# Maps each internal symbol node to its project via the project_root column.
#
# Output columns: :START_ID(ScipNode),:END_ID(ScipNode),:TYPE
# The project :END_ID matches the fqn:ID(ScipNode) in scip_projects_admin.csv.
# ---------------------------------------------------------------------------

function produce_project_links_admin() {
    local symbol_nodes_file="${1}"
    local output_file="${2}"

    {
        echo '":START_ID(ScipNode)",":END_ID(ScipNode)",":TYPE"'
        # Input columns: symbol,display_name,scheme,language,kind,symbol_type,file,...,project_root,descriptor
        # project_root is column 14 (1-based); skip header
        awk -F',' 'NR > 1 {
            symbol       = $1
            project_root = $14
            gsub(/^"/, "", project_root)
            gsub(/"$/, "", project_root)
            if (project_root == "") next

            # Derive project fqn (must match transform_projects_to_admin)
            fqn = project_root
            gsub(/[^A-Za-z0-9._-]/, "_", fqn)

            key = symbol SUBSEP fqn
            if (!seen[key]++) {
                print symbol ",\"" fqn "\",\"BELONGS_TO\""
            }
        }' "${symbol_nodes_file}"
    } > "${output_file}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: INDICES_DIRECTORY=${INDICES_DIRECTORY}"
echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: IMPORT_DIRECTORY=${IMPORT_DIRECTORY}"

validate_prerequisites

# Step 1: produce canonical LOAD CSV format files
echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Running cross-file extraction..."
INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" \
    bash "${CROSS_FILE_SCRIPT}"

# Step 2: transform to neo4j-admin import format
readonly SYMBOL_NODES_CSV="${IMPORT_DIRECTORY}/scip_symbol_nodes.csv"
readonly EXTERNAL_NODES_CSV="${IMPORT_DIRECTORY}/scip_external_symbol_nodes.csv"
readonly EDGES_CSV="${IMPORT_DIRECTORY}/scip_symbol_edges.csv"
readonly PROJECTS_CSV="${IMPORT_DIRECTORY}/scip_projects.csv"

readonly SYMBOL_NODES_ADMIN="${IMPORT_DIRECTORY}/scip_symbol_nodes_admin.csv"
readonly EXTERNAL_NODES_ADMIN="${IMPORT_DIRECTORY}/scip_external_symbol_nodes_admin.csv"
readonly EDGES_ADMIN="${IMPORT_DIRECTORY}/scip_symbol_edges_admin.csv"
readonly PROJECTS_ADMIN="${IMPORT_DIRECTORY}/scip_projects_admin.csv"
readonly LINKS_ADMIN="${IMPORT_DIRECTORY}/scip_symbol_project_links_admin.csv"

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Transforming internal symbol nodes -> '${SYMBOL_NODES_ADMIN}'..."
transform_symbol_nodes_to_admin "${SYMBOL_NODES_CSV}" "${SYMBOL_NODES_ADMIN}"

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Transforming external symbol nodes -> '${EXTERNAL_NODES_ADMIN}'..."
transform_external_symbol_nodes_to_admin "${EXTERNAL_NODES_CSV}" "${EXTERNAL_NODES_ADMIN}"

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Transforming edges -> '${EDGES_ADMIN}'..."
transform_edges_to_admin "${EDGES_CSV}" "${EDGES_ADMIN}"

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Transforming projects -> '${PROJECTS_ADMIN}'..."
transform_projects_to_admin "${PROJECTS_CSV}" "${PROJECTS_ADMIN}"

echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Producing project links -> '${LINKS_ADMIN}'..."
produce_project_links_admin "${SYMBOL_NODES_CSV}" "${LINKS_ADMIN}"

symbol_node_count=$(( $(wc -l < "${SYMBOL_NODES_ADMIN}") - 1 ))
external_node_count=$(( $(wc -l < "${EXTERNAL_NODES_ADMIN}") - 1 ))
edge_count=$(( $(wc -l < "${EDGES_ADMIN}") - 1 ))
project_count=$(( $(wc -l < "${PROJECTS_ADMIN}") - 1 ))
link_count=$(( $(wc -l < "${LINKS_ADMIN}") - 1 ))
echo "convertScipIndexToCsvForNeo4jAdminCrossFileImport: Done. ${symbol_node_count} internal node(s), ${external_node_count} external node(s), ${edge_count} edge(s), ${project_count} project(s), ${link_count} project link(s)."
