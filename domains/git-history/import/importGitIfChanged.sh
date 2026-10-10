#!/usr/bin/env bash

# Runs importGit.sh only when source/ contents changed since the last successful import, using SHA-based change detection.
# On unchanged source the import is skipped. When IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=none or source/ is absent, always skips.
# Supports --dry-run: reports whether the import would run without executing it (useful for testing).
# Requires importGit.sh, detectChangedFiles.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Source directory containing git repositories
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT:-"plugin"} # Select how to import git log data. Options: "none", "aggregated", "full" and "plugin". Default="plugin".

## Get this "import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GIT_HISTORY_IMPORT_DIR=${GIT_HISTORY_IMPORT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "importGitIfChanged: GIT_HISTORY_IMPORT_DIR=${GIT_HISTORY_IMPORT_DIR}"

# Get the central "scripts" directory by navigating three levels up from this domain's import directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GIT_HISTORY_IMPORT_DIR}/../../../scripts"}
echo "importGitIfChanged: SCRIPTS_DIR=${SCRIPTS_DIR}"
echo "importGitIfChanged: SOURCE_DIRECTORY=${SOURCE_DIRECTORY}"
echo "importGitIfChanged: IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}"

# SHA file that records source directory state after the last successful import.
# Stored alongside the source repositories — mirrors how indices/scipIndexChangeDetection.sha is stored with SCIP files.
GIT_IMPORT_CHANGE_DETECTION_HASH_FILE="${SOURCE_DIRECTORY}/gitImportChangeDetection.sha"

# --dry-run option: reports what would happen without executing the import
dry_run=false
USAGE="importGitIfChanged: Usage: $0 [--dry-run]"
while [ "$#" -gt "0" ]; do
  case "$1" in
    --dry-run) dry_run=true ;;
    *) echo "importGitIfChanged: Error: Unknown option: $1" >&2; echo "${USAGE}" >&2; exit 1 ;;
  esac
  shift
done

# Skip if import is disabled
if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "none" ]; then
  echo "importGitIfChanged: Skipped (IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=none)."
  return 0
fi

# Skip if source directory does not exist
if [ ! -d "${SOURCE_DIRECTORY}" ]; then
  echo "importGitIfChanged: Source directory '${SOURCE_DIRECTORY}' not found. Skipped."
  return 0
fi

# Returns exit 0 (true) when source/ changed since last import; exit 1 (false) when unchanged.
is_source_change_detected() {
  local result
  # shellcheck disable=SC1090,SC1091
  result=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" \
      --readonly \
      --hashfile "${GIT_IMPORT_CHANGE_DETECTION_HASH_FILE}" \
      --paths "${SOURCE_DIRECTORY}" )
  [ "${result}" != "0" ]
}

# Writes the current source directory hash to the change detection file after a successful import.
write_git_import_change_detection_hash() {
  local _hash
  # shellcheck disable=SC1090,SC1091
  _hash=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" \
      --hashfile "${GIT_IMPORT_CHANGE_DETECTION_HASH_FILE}" \
      --paths "${SOURCE_DIRECTORY}" ) || true
}

if ! is_source_change_detected; then
  echo "importGitIfChanged: Source directory unchanged. Git import skipped."
  return 0
fi

echo "importGitIfChanged: Source directory changed. Running git import (mode=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT})..."

if ${dry_run}; then
  echo "importGitIfChanged: --dry-run active. Import skipped."
  return 0
fi

# shellcheck disable=SC1090,SC1091
source "${GIT_HISTORY_IMPORT_DIR}/importGit.sh"

write_git_import_change_detection_hash
echo "importGitIfChanged: Git import complete. Change detection hash updated."
