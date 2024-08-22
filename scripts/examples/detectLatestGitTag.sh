#!/usr/bin/env bash

# Returns the latest tag of a remote repository given by its url.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Display how this command is intended to be used including an example when wrong input parameters were detected
usage() {
  echo "" >&2
  echo "Usage:   $0 --url <git-clone-url> [--prefix <tag prefix to ignore>]" >&2
  echo "Example: $0 --url https://github.com/ant-design/ant-design.git" >&2
  exit 1
}

# Default command line option values
url=""
prefix=""

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="${1}"
  value="${2}"

  case "${key}" in
    --url)
      url="${value}"
      shift
      ;;
    --prefix)
      prefix="${value}"
      shift
      ;;
    *)
      echo "detectLatestVersion Error: Unknown option: ${key}" >&2
      usage
      ;;
  esac
  shift
done

if [ -n "${url}" ]; then
  # url specified -> check if it is a valid URL
  if ! curl --head --fail --max-time 20 "${url}" >/dev/null 2>&1; then
    echo "detectLatestVersion Error: Invalid URL: ${url}" >&2
    exit 1
  fi
else
  echo "detectLatestVersion: Error: Please specify an url." >&2
fi

if [ -n "${prefix}" ]; then
  echo "detectLatestVersion: Ignoring tag prefix '${prefix}'." >&2
fi


# Check if the command succeeded
if ! projectVersion=$( git ls-remote --sort "-version:refname" --tags "${url}" \
                     | grep -E "refs/tags/${prefix:-.*}[0-9]+.*\w$" \
                     | sed -n '1p' \
                     | sed "s/.*\/${prefix}//" \
                     )
then
  redColor='\033[0;31m'
  noColor='\033[0m'
  echo -e "${redColor}detectLatestVersion: Error: Failed to detect latest git tag for ${url}($?):${noColor}" >&2
  echo -e "${redColor}${projectVersion}${noColor}" >&2
  exit 1
fi
# echo "detectLatestVersion: Detected latest version ${projectVersion} for ${url}." >&2

# # Retrieve latest release from GitHub API 
# # Extract the owner and repo of the url 
# url_without_github_domain="${url#https://github.com/}"
# owner_and_repo="${url_without_github_domain%.*}"
# github_latest_release_endpoint_url="https://api.github.com/repos/${owner_and_repo}/releases/latest"
#
# if ! projectVersion=$( curl --silent --fail-with-body "${github_latest_release_endpoint_url}" \
#                      | grep '"tag_name":' \
#                      | sed -E 's/.*"([^"]+)".*/\1/'\
#                      )
# then
#   redColor='\033[0;31m'
#   noColor='\033[0m'
#   echo -e "${redColor}detectLatestVersion: Error: Failed to detect latest version for ${github_latest_release_endpoint_url}($?):${noColor}" >&2
#   echo -e "${redColor}${projectVersion}${noColor}" >&2
#   exit 1
# fi
#
# echo "detectLatestVersion: Detected latest GitHub release ${projectVersion} for ${github_latest_release_endpoint_url}." >&2

# Print the latest version as result
echo "${projectVersion}"