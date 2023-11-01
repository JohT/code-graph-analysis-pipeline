#!/usr/bin/env bash

# Provides operating system dependent functions e.g. to detect Windows.

# Requires executeQuery.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts

# Return true if the script is running on Windows, otherwise false.
# Example: if isWindows; then echo "Running on Windows"
isWindows() {
    [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]
}

# Echoes/Returns the first argument if the script is running on Windows, otherwise the second argument.
# Example: artifactPostfix=$(ifWindows "windows.zip" "unix.tar.gz")
ifWindows() {
    if isWindows; then
        echo "$1"
    else
        echo "$2"
    fi
}

# Prints out a message if Windows was detected for the current OSTYPE or not.
# Example: printWindows
printWindows() {
    ifWindows "operatingSystemFunctions: Detected Windows for OSTYPE ${OSTYPE}" "operatingSystemFunctions: No Windows detected for OSTYPE ${OSTYPE}"
}

# Converts the POSIX path given as the first argument to Windows path format if the script is running on Windows.
# Otherwise it just returns the path unchanged (for non-windows systems).
# Example: path=$(convertPosixToWindowsPath "${path}")
convertPosixToWindowsPathIfNecessary() {
    if isWindows; then
        echo "$1" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/'
    else
        echo "$1"
    fi
}

printWindows