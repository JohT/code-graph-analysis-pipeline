#!/usr/bin/env bash

# Runs all Python unit tests (pytest). Discovers test*.py files in domains directory.
# Requires pytest, pandas, matplotlib to be installed.

set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

LOG_GROUP_START=${LOG_GROUP_START:-"::group::"}
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"}

SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY:-"${SCRIPTS_DIR}/../domains"}

command -v pytest >/dev/null || { echo "pytest not found. Install with: pip install pytest"; exit 1; }

test_files=()
while IFS= read -r test_file; do
    test_files+=("${test_file}")
done < <(find "${DOMAINS_DIRECTORY}" -type f -name 'test*.py' | sort)

if [ ${#test_files[@]} -eq 0 ]; then
    echo "runPythonTests: No test*.py files found in ${DOMAINS_DIRECTORY}"
    exit 0
fi

echo "${LOG_GROUP_START}Run Python Tests"
echo "runPythonTests: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting Python tests..."

pytest --verbose "${test_files[@]}"

echo "runPythonTests: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished Python tests"
echo "${LOG_GROUP_END}"
