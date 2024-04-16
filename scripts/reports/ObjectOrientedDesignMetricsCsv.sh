#!/usr/bin/env bash

# Executes "Metrics" Cypher queries to get the "object-oriented-design-metrics-csv" CSV reports.
# It contains lists of e.g. incoming and outgoing package dependencies,
# abstractness, instability and the distance to the so called "main sequence".

# Requires executeQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "ObjectOrientedDesignMetricsCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "ObjectOrientedDesignMetricsCsv SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "ObjectOrientedDesignMetricsCsv CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="object-oriented-design-metrics-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
METRICS_CYPHER_DIR="${CYPHER_DIR}/Metrics"

# Java Packages only without sub-packages
echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing Java packages without sub-packages..."
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Incoming_Java_Package_Dependencies.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Incoming_Java_Package_Dependencies.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/IncomingPackageDependenciesJava.csv"
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Outgoing_Java_Package_Dependencies.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Outgoing_Java_Package_Dependencies.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/OutgoingPackageDependenciesJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Java.cypher" > "${FULL_REPORT_DIRECTORY}/InstabilityJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Java.cypher" > "${FULL_REPORT_DIRECTORY}/AbstractnessJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Java.cypher" > "${FULL_REPORT_DIRECTORY}/MainSequenceAbstractnessInstabilityDistanceJava.csv"

# Java Packages including sub-packages (overlapping/redundant)
#   Since Java Packages are organized hierarchically, 
#   incoming dependencies can also be calculated by including all of their sub-packages. 
#   Top level packages like for example "org" and "org.company" are left out 
#   by assuring that only those packages are considered, 
#   that have other packages or types in the same hierarchy level ("siblings").
echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing packages including sub-packages..."
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Incoming_Java_Package_Dependencies_Including_Subpackages.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Incoming_Java_Package_Dependencies_Including_Subpackages.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/IncomingPackageDependenciesIncludingSubpackagesJava.csv"
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Outgoing_Java_Package_Dependencies_Including_Subpackages.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Outgoing_Java_Package_Dependencies_Including_Subpackages.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/OutgoingPackageDependenciesIncludingSubpackagesJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Java_Including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/InstabilityIncludingSubpackagesJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Java_including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/AbstractnessIncludingSubpackagesJava.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Java_including_subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/MainSequenceAbstractnessInstabilityDistanceIncludingSubpackagesJava.csv"

# Typescript Modules
echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing Typescript modules..."
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Incoming_Typescript_Module_Dependencies.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Incoming_Typescript_Module_Dependencies.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/IncomingPackageDependenciesTypescript.csv"
execute_cypher_queries_until_results "${METRICS_CYPHER_DIR}/Get_Outgoing_Typescript_Module_Dependencies.cypher" \
                                     "${METRICS_CYPHER_DIR}/Set_Outgoing_Typescript_Module_Dependencies.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/OutgoingPackageDependenciesTypescript.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/InstabilityTypescript.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/AbstractnessTypescript.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/MainSequenceAbstractnessInstabilityDistanceTypescript.csv"

echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."