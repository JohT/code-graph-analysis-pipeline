#!/usr/bin/env bash

# Echoes a list of Typescript data files starting with "ts-" and having extension "json" in the artifacts directory of sub directories. 
# Each name will be prefixed by "typescript:project::"and separated by one space character.
# This list is meant to be used after the "-f" line command option for the jQAssistant scan command to include Typescript data files.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}

# Check if the artifacts directory exists
if [ ! -d "./${ARTIFACTS_DIRECTORY}" ] ; then
    echo "" # The artifact directory doesn't exist. There is no file at all.
    exit 0
fi

find "./${ARTIFACTS_DIRECTORY}" -type f -name 'ts-*.json' -exec echo {} \; | sed 's/^/typescript:project::/' | tr '\n' ' ' 