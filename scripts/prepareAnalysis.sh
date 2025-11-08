#!/usr/bin/env bash

# Prepares and validates the graph database before analysis 

# Requires executeQueryFunctions.sh, parseCsvFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT:-"full"} # Select how to import git log data. Options: "none", "aggregated", "full". Default="full".

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "prepareAnalysis: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "prepareAnalysis: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Get the "cypher" directory by taking the path of this script, going one directory up and then into "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"} # Repository directory containing the cypher queries
echo "prepareAnalysis: CYPHER_DIR=${CYPHER_DIR}"

# Define functions (like execute_cypher) to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions (like is_csv_column_greater_zero) to parse CSV format strings from Cypher query results.
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

# Local Constants
DEPENDS_ON_CYPHER_DIR="$CYPHER_DIR/DependsOn_Relationship_Weights"
METRICS_CYPHER_DIR="$CYPHER_DIR/Metrics"
EXTERNAL_DEPENDENCIES_CYPHER_DIR="$CYPHER_DIR/External_Dependencies"
ARTIFACT_DEPENDENCIES_CYPHER_DIR="$CYPHER_DIR/Artifact_Dependencies"
TYPES_CYPHER_DIR="$CYPHER_DIR/Types"
TYPESCRIPT_CYPHER_DIR="$CYPHER_DIR/Typescript_Enrichment"
GENERAL_ENRICHMENT_CYPHER_DIR="${CYPHER_DIR}/General_Enrichment"

COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_DEFAULT='\033[0m'

# Preparation - Data verification: DEPENDS_ON relationships
dataVerificationResult=$( execute_cypher "${CYPHER_DIR}/Data_verification_DEPENDS_ON_relationships.cypher" "${@}")
if ! is_csv_column_greater_zero "${dataVerificationResult}" "sourceNodeCount"; then
    echo -e "${COLOR_RED}prepareAnalysis: Error: Data verification failed. At least one DEPENDS_ON relationship is required. Check if the artifacts directory is empty or if the scan failed.${COLOR_DEFAULT}"
    echo -e "${COLOR_RED}${dataVerificationResult}${COLOR_DEFAULT}"
    exit 1
fi

# Preparation - Create indices
execute_cypher "${CYPHER_DIR}/Create_Java_Type_index_for_full_qualified_name.cypher"
execute_cypher "${CYPHER_DIR}/Create_Typescript_index_for_full_qualified_name.cypher"
execute_cypher "${CYPHER_DIR}/Create_Typescript_index_for_name.cypher"

# Preparation - General Enrichment - Add properties "name" and "extension" to all File nodes
execute_cypher "${GENERAL_ENRICHMENT_CYPHER_DIR}/Add_file_name and_extension.cypher"

# Preparation - Enrich Graph for Typescript by adding "module" and "name" properties
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Index_module_name.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_module_properties.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Set_localRootPath_for_modules.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Mark_test_modules.cypher"

# Preparation - Enrich Graph for Typescript by adding a name properties
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_name_to_property_on_projects.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_name_to_property_on_scan_nodes.cypher"

# Preparation - Cleanup Graph for Typescript by removing duplicate relationships
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Remove_duplicate_CONTAINS_relations_between_files.cypher"

# Preparation - Enrich Graph for Typescript by adding relationships between corresponding TS:Project and NPM:Package nodes
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Link_npm_dependencies_to_npm_packages.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Link_projects_to_npm_packages.cypher"
dataVerificationResult=$( execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Verify_projects_linked_to_npm_packages.cypher" "${@}")
if is_csv_column_greater_zero "${dataVerificationResult}" "unresolvedProjectsCount"; then
    # Warning: There are Typescript projects that are not linked to NPM Packages (unresolvedProjectsCount is greater than zero).
    #          It is possible to have projects with a tsconfig.json file but without a package.json e.g. for testing purposes.
    echo -e "${COLOR_YELLOW}prepareAnalysis: Data verification warning: There are Typescript projects that are not linked to a npm package:${COLOR_DEFAULT}"
    echo -e "${COLOR_YELLOW}${dataVerificationResult}${COLOR_DEFAULT}"
    # Since this is now only a warning, execution will be continued.
fi
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Link_external_modules_to_corresponding_npm_dependency.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_namespace_property_on_nodes_from_linked_npm_packages.cypher"

# Preparation - Enrich Graph for Typescript by adding relationships between Modules with the same globalFqn
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_IS_IMPLEMENTED_IN_relationship_for_matching_modules.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_IS_IMPLEMENTED_IN_relationship_for_matching_declarations.cypher"
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_DEPENDS_ON_relationship_to_resolved_modules.cypher"

dataVerificationResult=$( execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Verify_module_dependencies.cypher" "${@}")
if ! is_csv_column_greater_zero "${dataVerificationResult}" "typescriptModuleDependenciesValid"; then
    # Warning: Very small Typescript projects might not have dependencies between their modules.
    #          Therefore, it will only be a warning even though for example anomaly detection will not lead to any useable results.
    echo -e "${COLOR_YELLOW}prepareAnalysis: Data verification warning: Typescript module dependencies are missing! Results based on those will be missing or empty:${COLOR_DEFAULT}"
    echo -e "${COLOR_YELLOW}${dataVerificationResult}${COLOR_DEFAULT}"
    # Since this is now only a warning, execution will be continued.
fi

# Preparation - Add weights to Java Package DEPENDS_ON relationships 
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_weight_property_for_Java_Interface_Dependencies_to_Package_DEPENDS_ON_Relationship.cypher"
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_weight_property_to_Java_Package_DEPENDS_ON_Relationship.cypher"
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_weight25PercentInterfaces_to_Java_Package_DEPENDS_ON_relationships.cypher" 
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_weight10PercentInterfaces_to_Java_Package_DEPENDS_ON_relationships.cypher"

# Preparation - Add weights to Typescript Module DEPENDS_ON relationships
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_fine_grained_weights_for_Typescript_external_module_dependencies.cypher"
execute_cypher_summarized "${DEPENDS_ON_CYPHER_DIR}/Add_fine_grained_weights_for_Typescript_internal_module_dependencies.cypher"

# Preparation - Add Typescript Module node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Incoming_Typescript_Module_Dependencies.cypher"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Outgoing_Typescript_Module_Dependencies.cypher"

# Preparation - Add Java Package node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Incoming_Java_Package_Dependencies.cypher"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Outgoing_Java_Package_Dependencies.cypher"

# Preparation - Add Java Method node property "declaringType"
execute_cypher "${TYPES_CYPHER_DIR}/Set_declaring_type_on_method_nodes.cypher"

# Preparation - Label external types and annotations
#               "external" means that there is no byte code available, not a primitive type and not a java type
#               "annotation" means that there is a ANNOTATED_BY to that external type
execute_cypher "${TYPES_CYPHER_DIR}/Remove_extended_type_labels.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_base_java_types.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_buildin_java_types.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_resolved_duplicate_types.cypher"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Remove_external_type_and_annotation_labels.cypher"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Label_external_types_and_annotations.cypher"

# Preparation - Add Java Artifact node properties "incomingDependencies", "outgoingDependencies" and "version"
execute_cypher_summarized "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Incoming_Java_Artifact_Dependencies.cypher"
execute_cypher_summarized "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Outgoing_Java_Artifact_Dependencies.cypher"
execute_cypher_summarized "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Set_maven_artifact_version.cypher"

# Preparation - Add Java Type node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Incoming_Java_Type_Dependencies.cypher"
execute_cypher_summarized "${METRICS_CYPHER_DIR}/Set_Outgoing_Java_Type_Dependencies.cypher"

echo "prepareAnalysis: Preparation successful"