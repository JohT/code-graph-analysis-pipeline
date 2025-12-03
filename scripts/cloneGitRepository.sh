#!/usr/bin/env bash

# Provides safe-guarded (security checked parameters) git repository cloning.

# Note: This script needs the path to target directory to clone the git repository to. It defaults to SOURCE_DIRECTORY ("source"). 
# Note: This script needs git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")

# Local constants
SCRIPT_NAME=$(basename "${0}")

fail() {
  local ERROR_COLOR='\033[0;31m' # red
  local DEFAULT_COLOR='\033[0m'
  local errorMessage="${1}"
  echo -e "${ERROR_COLOR}${SCRIPT_NAME}: Error: ${errorMessage}${DEFAULT_COLOR}" >&2
  exit 1
}

# Default and initial values for command line options
url=""
branch="main"
history_only="false"
target="${SOURCE_DIRECTORY}"
dry_run="false"

# Read command line options
USAGE="${SCRIPT_NAME}: Usage: $0 --url <github-repository-url> --branch <branch-name> [--history-only <true|false>] [--target <clone directory>(default=source)]"

while [ "$#" -gt "0" ]; do
  key="$1"
  case ${key} in
    --url)
      url="$2"
      shift
      ;;
    --branch)
      branch="$2"
      shift
      ;;
    --history-only)
      history_only="$2"
      shift
      ;;
    --target)
      target="$2"
      shift
      ;;
    --dry-run)
      dry_run="true"
      ;;
    *)
      fail "Unknown option: ${key}"
      echo "${USAGE}" >&2
      exit 1
  esac
  shift
done

# --- Validate URL (mandatory)
if [ -z "${url}" ] ; then
  fail "The git repository URL (--url) must be provided."
  echo "${USAGE}" >&2
  exit 1
fi
case "${url}" in
  https://github.com/*/*|https://github.com/*/*.git)
    ;;
  *)
    fail "The source repository (--url) must be a valid GitHub repository URL."
    ;;
esac

# --- Validate branch (mandatory, defaults to "main")
if [ -z "${branch}" ] ; then
  fail "The git repository branch (--branch) must be provided."
  echo "${USAGE}" >&2
  exit 1
fi
case "${branch}" in
  *[\ ~^:?*[\]\\]*)
    fail "The source repository branch contains invalid characters."
    ;;
esac

# --- Validate history-only (mandatory, defaults to "false")
case "${history_only}" in
  true|false)
    ;;
  *)
    fail "The source repository history-only option must be either 'true' or 'false'."
    echo "${USAGE}" >&2
    ;;
esac

# --- Validate target directory (mandatory, defaults to SOURCE_DIRECTORY)
if [ -z "${target}" ] ; then
  fail "The target directory (--target) ${target} must be provided." >&2
  echo "${USAGE}" >&2
  exit 1
else
  mkdir -p "${target}"
fi

if [ ${dry_run} = "true" ] ; then
  echo "Dry run mode enabled. The following command(s) would be executed:" >&2
fi

# --- Clone the git repository
bare_option=""
bare_folder=""
if [ "${history_only}" = "true" ]; then
  bare_option="--bare"
  bare_folder="/.git" # bare clones need the .git folder to be used as target
fi

if [ ${dry_run} = "true" ] ; then
  echo "git clone ${bare_option} --single-branch ${url} --branch ${branch} ${target}${bare_folder}"
  exit 0
else
  git clone ${bare_option} --single-branch  "${url}" --branch "${branch}" "${target}${bare_folder}"
fi