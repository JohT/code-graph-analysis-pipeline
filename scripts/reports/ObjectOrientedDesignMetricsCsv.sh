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

echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing packages without sub-packages..."

# Packages only without sub-packages
execute_cypher "${METRICS_CYPHER_DIR}/Set_Incoming_Package_Dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/IncomingPackageDependencies.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Set_Outgoing_Package_Dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/OutgoingPackageDependencies.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Instability_outgoing_incoming_Dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/Instability.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_including_Counts.cypher" > "${FULL_REPORT_DIRECTORY}/Abstractness.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability.cypher" > "${FULL_REPORT_DIRECTORY}/MainSequenceAbstractnessInstabilityDistance.csv"


# Packages including sub-packages (overlapping/redundant)
#   Since Java Packages are organized hierarchically, 
#   incoming dependencies can also be calculated by including all of their sub-packages. 
#   Top level packages like for example "org" and "org.company" are left out 
#   by assuring that only those packages are considered, 
#   that have other packages or types in the same hierarchy level ("siblings").
echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing packages including sub-packages..."
execute_cypher "${METRICS_CYPHER_DIR}/Set_Incoming_Package_Dependencies_Including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/IncomingPackageDependenciesIncludingSubpackages.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Set_Outgoing_Package_Dependencies_Including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/OutgoingPackageDependenciesIncludingSubpackages.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Instability_Including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/InstabilityIncludingSubpackages.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_including_Subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/AbstractnessIncludingSubpackages.csv"
execute_cypher "${METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_including_subpackages.cypher" > "${FULL_REPORT_DIRECTORY}/MainSequenceAbstractnessInstabilityDistanceIncludingSubpackages.csv"

echo "ObjectOrientedDesignMetricsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."