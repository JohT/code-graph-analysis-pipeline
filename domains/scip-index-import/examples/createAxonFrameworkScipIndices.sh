#!/usr/bin/env bash

# Creates per-module SCIP indices for AxonFramework using scip-java and the scip CLI.
# Indexes 5 modules: common, conversion, modelling, eventsourcing, messaging.
# Outputs .scip.json files to ${PROJECT_ROOT}/target/scip-indices-per-module/.
#
# Requires PROJECT_ROOT env var pointing to the AxonFramework source root.
# Requires scip-java (domains/scip-index-import/examples/installScipJava.sh).
# Requires scip CLI (domains/scip-index-import/examples/installScipCli.sh).

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

if [ -z "${PROJECT_ROOT:-}" ]; then
    echo "${SCRIPT_NAME}: Error: PROJECT_ROOT must be set to the AxonFramework source root." >&2
    exit 1
fi

# Compute absolute path to the pipeline repository root (3 levels up from examples/)
PIPELINE_ROOT=$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." >/dev/null && pwd -P )

# Derive absolute tool paths so sourced functions work regardless of working directory
SCIP_JAVA=${SCIP_JAVA:-"${PIPELINE_ROOT}/tools/scip-java/scip-java"}
SCIP=${SCIP:-"${PIPELINE_ROOT}/tools/scip-cli/scip"}
export SCIP_JAVA SCIP

# shellcheck source=domains/scip-index-import/examples/createScipIndexFunctionsForJava.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/createScipIndexFunctionsForJava.sh"

echo "${SCRIPT_NAME}: Indexing AxonFramework modules in ${PROJECT_ROOT}"
echo "${SCRIPT_NAME}: Output directory: ${OUTPUT_DIR}"

# Index a module with GitHub Actions grouping and placeholder resolution
process_axon_framework_module() {
  local module_name="$1"
  echo "::group::Indexing ${module_name}"
  index_module "${module_name}"
  resolve_placeholders_in_json "${module_name}" "revision"
  echo "::endgroup::"
}

# Index each module with per-module GitHub Actions grouping
process_axon_framework_module "common"
process_axon_framework_module "conversion"
process_axon_framework_module "modelling"
process_axon_framework_module "eventsourcing"
process_axon_framework_module "messaging"

echo "::notice::SCIP indices created successfully in ${OUTPUT_DIR}"
