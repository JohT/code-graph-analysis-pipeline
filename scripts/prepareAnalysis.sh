#!/usr/bin/env bash

# Prepares and validates the graph database before analysis 

# Requires executeQueryFunctions.sh, parseCsvFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

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

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define function(s) (e.g. is_csv_column_greater_zero) to parse CSV format strings from Cypher query results.
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

# Local Constants
PACKAGE_WEIGHTS_CYPHER_DIR="$CYPHER_DIR/Package_Relationship_Weights"
PACKAGE_METRICS_CYPHER_DIR="$CYPHER_DIR/Metrics"
EXTERNAL_DEPENDENCIES_CYPHER_DIR="$CYPHER_DIR/External_Dependencies"
ARTIFACT_DEPENDENCIES_CYPHER_DIR="$CYPHER_DIR/Artifact_Dependencies"
TYPES_CYPHER_DIR="$CYPHER_DIR/Types"

# Preparation - Data verification: DEPENDS_ON releationships
dataVerificationResult=$( execute_cypher "${CYPHER_DIR}/Data_verification_DEPENDS_ON_relationships.cypher" "${@}")
if ! is_csv_column_greater_zero "${dataVerificationResult}" "sourceNodeCount"; then
    echo "prepareAnalysis: Error: Data verification failed. At least one DEPENDS_ON relationship required. Check if the artifacts directory is empty or if the scan failed."
    exit 1
fi

# Preparation - Create indices
execute_cypher "${CYPHER_DIR}/Create_index_for_full_qualified_type_name.cypher"

# Preparation - Create DEPENDS_ON for every DEPENDS_ON_* relationship
# Workaround for https://github.com/jQAssistant/jqa-java-plugin/issues/44
# execute_cypher "${CYPHER_DIR}/Create_a_DEPENDS_ON_relationship_for_every_DEPENDS_ON_PACKAGE.cypher"
# execute_cypher "${CYPHER_DIR}/Create_a_DEPENDS_ON_relationship_for_every_DEPENDS_ON_ARTIFACT.cypher"

# Preparation - Add weights to package DEPENDS_ON relationships 
execute_cypher_expect_results "${PACKAGE_WEIGHTS_CYPHER_DIR}/Add_weight_property_for_Interface_Dependencies_to_Package_DEPENDS_ON_Relationship.cypher"
execute_cypher_expect_results "${PACKAGE_WEIGHTS_CYPHER_DIR}/Add_weight_property_to_Package_DEPENDS_ON_Relationship.cypher"
execute_cypher_expect_results "${PACKAGE_WEIGHTS_CYPHER_DIR}/Add_weight25PercentInterfaces_to_Package_DEPENDS_ON_relationships.cypher" 
execute_cypher_expect_results "${PACKAGE_WEIGHTS_CYPHER_DIR}/Add_weight10PercentInterfaces_to_Package_DEPENDS_ON_relationships.cypher"

# Preparation - Add Package node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_expect_results "${PACKAGE_METRICS_CYPHER_DIR}/Set_Incoming_Package_Dependencies.cypher"
execute_cypher_expect_results "${PACKAGE_METRICS_CYPHER_DIR}/Set_Outgoing_Package_Dependencies.cypher"

# Preparation - Label external types and annotations
#               "external" means that there is no byte code available, not a primitive type and not a java type
#               "annoatation" means that there is a ANNOTATED_BY to that external type
execute_cypher "${TYPES_CYPHER_DIR}/Remove_extended_type_labels.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_base_java_types.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_buildin_java_types.cypher"
execute_cypher "${TYPES_CYPHER_DIR}/Label_resolved_duplicate_types.cypher"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Remove_external_type_and_annotation_labels.cypher"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Label_external_types_and_annotations.cypher"

# Preparation - Add Artifact node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_expect_results "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Incoming_Artifact_Dependencies.cypher"
execute_cypher_expect_results "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Outgoing_Artifact_Dependencies.cypher"

# Preparation - Add Type node properties "incomingDependencies" and "outgoingDependencies"
execute_cypher_expect_results "${PACKAGE_METRICS_CYPHER_DIR}/Set_Incoming_Type_Dependencies.cypher"
execute_cypher_expect_results "${PACKAGE_METRICS_CYPHER_DIR}/Set_Outgoing_Type_Dependencies.cypher"

echo "prepareAnalysis: Preparation successful"