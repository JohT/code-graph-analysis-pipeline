#!/usr/bin/env bash

# Check environment dependencies and tool availability.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
#echo "checkCompatibility: SCRIPTS_DIR=${SCRIPTS_DIR}"

checkCommand() {
    local cmd="$1"
    local description="$2"
    local missing_icon="$3"
    local present_icon="${4:-✅}"

    if command -v "${cmd}" &> /dev/null; then
        echo "  ${present_icon} ${cmd} - ${description}"
    else
        echo "  ${missing_icon} ${cmd} - ${description}"
    fi
}

checkRequiredCommand() {
    checkCommand "$1" "$2" "❌" ""
}

checkOptionalCommand() {
    checkCommand "$1" "$2" "⚠️ " "✅"
}

checkRequiredJavaVersion() {
    required_java_version="$1"

    if [ -z "${required_java_version}" ]; then
        echo "Usage: check_java_version <major-version>" 1>&2
        return 2
    fi

    if ! command -v "java" &> /dev/null; then
        echo "  ❌ java - Java Development Kit (https://adoptium.net/) for running Java applications is not installed."
        return 0
    fi
    # Capture the first line of `java -version` (macOS & Linux both print to stderr)
    java_version_output=$(java -version 2>&1 | head -n 1)

    # Extract the version inside the first quotes
    # Examples:
    #   openjdk version "17.0.2"
    #   java version "1.8.0_312"
    # Use shell parameter expansion instead of external sed for portability and performance
    full_java_version="${java_version_output#*\"}"
    java_version="${full_java_version%%\"*}"

    # Extract major version number supporting both Java 8 and older (1.x) and Java 9+ formats
    case "${java_version}" in
        1.*)
            # Java 8 and older -> "1.8.0_xxx" → major = 8
            java_version="${java_version#1.}"
            java_version="${java_version%%.*}"
            ;;
        *)
            # Java 9+ -> "17.0.2" → major = 17
            java_version="${java_version%%.*}"
            ;;
    esac

    # Compare numeric versions
    if [ "${java_version}" -ge "${required_java_version}" ]; then
        echo "  ✅ java - Java version ${java_version} meets required version ${required_java_version}"
    else
        echo "  ❌ java - Java version ${required_java_version} or higher is required, but found version ${java_version}"
    fi
}

oneOf() {
    for option in "$@"; do
        if command -v "$option" &> /dev/null; then
            echo "✅"
            return 0
        fi
    done
    echo "❌"
}

allOf() {
    for option in "$@"; do
        if ! command -v "$option" &> /dev/null; then
            echo "❌"
            return 0
        fi
    done
    echo "✅"
}

isFailed() {
    if [ "$1" = "❌" ]; then
        return 0
    else
        return 1
    fi
}

echo ""
echo "Checking environment dependencies and tool availability..."
echo ""
echo "--------------------------------"

# Check required main dependencies
icon=$(allOf "bash" "awk" "wc" "sed" "grep" "curl" "jq" "git" "java")
echo "${icon} Minimum required dependencies:"
checkRequiredCommand "bash" "Bourne Again SHell (https://www.gnu.org/software/bash/) for running the shell scripts"
checkRequiredCommand "awk" "Text processing tool (https://www.gnu.org/software/gawk/) for processing text files"
checkRequiredCommand "wc" "Word, line, character, byte count tool (https://www.gnu.org/software/coreutils/wc/) for counting lines in files"
checkRequiredCommand "sed" "Stream editor (https://www.gnu.org/software/sed/) for parsing and transforming text"
checkRequiredCommand "grep" "Text search tool (https://www.gnu.org/software/grep/) for text searching with regular expressions"
checkRequiredCommand "curl" "Command line tool for transferring data with URLs (https://curl.se/) for HTTP requests to Neo4j"
checkRequiredCommand "jq" "Command-line JSON processor (https://stedolan.github.io/jq/) for parsing JSON results from Neo4j"
checkRequiredCommand "git" "Version control system (https://git-scm.com/) for managing source code repositories"
checkRequiredJavaVersion "21"

if isFailed "${icon}"; then
    echo ""
    echo "${icon} One or more minimum required dependencies are missing. Please install them and re-run this script."
    echo "--------------------------------"
    echo ""
    exit 1
fi

# Check dependencies for Typescript project analysis:
icon=$(allOf "npx" "npm")
echo ""
echo "${icon} Typescript project analysis dependencies:"
checkRequiredCommand "npx" "Tool to run npm packages without installing them globally (https://docs.npmjs.com/cli/v9/commands/npx)"
checkRequiredCommand "npm" "Node.js package manager (https://docs.npmjs.com/) for managing JavaScript packages"

# Check dependencies for Python environments
icon=$(oneOf "conda" "venv")
echo ""
echo "${icon} Python environment dependencies (for ./analyze.sh --report Python/Jupyter):"
checkOptionalCommand "conda" "Conda package and environment manager (https://docs.conda.io/en/latest/)"
checkOptionalCommand "virtualenv" "Python virtual environment module (https://docs.python.org/3/library/venv.html)"

# Check dependencies for Python reports
icon=$(allOf "python" "pip")
echo ""
echo "${icon} Python reports dependencies (for ./analyze.sh --report Python/Jupyter):"
checkRequiredCommand "python" "Python interpreter (https://www.python.org/) for running Python scripts"
checkRequiredCommand "pip" "Python package installer (https://pip.pypa.io/en/stable/) for installing Python packages"

# Check dependencies for Jupyter Notebook reports
icon=$(allOf "python" "pip" "jupyter")
echo ""
echo "${icon} Python reports dependencies  (for ./analyze.sh --report Jupyter):"
# Since "jupyter" might only be available when the Python environment is activated, check for it only optionally
checkOptionalCommand "jupyter" "Jupyter Notebook (https://jupyter.org/) for interactive data analysis and visualization (will be available when the Python environment is activated)"

# Check dependencies for visualization reports
icon=$(oneOf "npx" "dot")
echo ""
echo "${icon} Visualization report dependencies (for ./analyze.sh --report Visualization):"
checkOptionalCommand "npx" "Tool to run npm packages without installing them globally (https://docs.npmjs.com/cli/v9/commands/npx)"
checkOptionalCommand "npm" "Node.js package manager (https://docs.npmjs.com/) for managing JavaScript packages"
checkOptionalCommand "dot" "Graph visualization tool from GraphViz (https://graphviz.org/) for visualizing query results as graphs"

echo "--------------------------------"
echo ""