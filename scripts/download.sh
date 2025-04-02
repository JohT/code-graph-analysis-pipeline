#!/usr/bin/env bash

# Downloads a file into the directory of the environment variable SHARED_DOWNLOADS_DIRECTORY (or default "../downloads").
# Does nothing if the file already exists.

# Command line options:
# --url Download URL (required)
# --filename Target file name with extension without path (optional, default = basename of download URL)

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Function to display script usage
usage() {
  echo "Usage: $0 --url https://my.download.url [--filename download-file-name-without-path.ext> (default=url filename)]"
  exit 1
}

# Default values
downloadUrl=""
filename=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --url)
      downloadUrl="$2"
      shift
      ;;
    --filename)
      filename="$2"
      shift
      ;;
    *)
      echo "download: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift
done

if [[ -z ${downloadUrl} ]]; then
  echo "${USAGE}"
  exit 1
fi

if [[ -z ${filename} ]]; then
  filename=$(basename -- "${downloadUrl}")
fi

# Get shared download directory and create it if it doesn't exist
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"
if [ ! -d "${SHARED_DOWNLOADS_DIRECTORY}" ] ; then
  echo "download: Creating shared downloads directory ${SHARED_DOWNLOADS_DIRECTORY}"
  mkdir -p ${SHARED_DOWNLOADS_DIRECTORY}
fi

# Download the file if it doesn't exist in the shared downloads directory 
if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${filename}" ] ; then
    echo "download: Downloading ${filename} from ${downloadUrl} into ${SHARED_DOWNLOADS_DIRECTORY}"

    # Check if the URL is valid
    # The check is deferred and not done in the input validation block at the beginning.
    # This is because the check needs a network connection which shouldn't be required when the file had already been downloaded.
    if ! curl --head --fail ${downloadUrl} >/dev/null 2>&1; then
      echo "download: Error: Invalid URL: ${downloadUrl}"
      exit 1
    fi

    # Download the file
    if ! curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${filename}" "${downloadUrl}"; then
        echo "download: Error: Failed to download ${filename}"
        rm -f "${SHARED_DOWNLOADS_DIRECTORY}/${filename}"
        exit 1
    fi
else
    echo "download: ${filename} already downloaded"
fi

# Check downloaded file size to be at least 600 bytes or otherwise delete the invalid file
downloaded_file_size=$(wc -c "${SHARED_DOWNLOADS_DIRECTORY}/${filename}" | awk '{print $1}')
if [[ "${downloaded_file_size}" -le 600 ]]; then
    echo "download: Error: Failed to download ${filename}: Filesize: ${downloaded_file_size} < 600 bytes"
    rm -f "${SHARED_DOWNLOADS_DIRECTORY}/${filename}"
    exit 1
fi

# Fail if download failed
if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${filename}" ] ; then
    echo "download: Error: Failed to download ${filename}"
    exit 1
fi