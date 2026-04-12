#!/usr/bin/env bash

# Detects if Neo4j is running and outputs its installation directory.
# Outputs "Neo4j not running" or "Neo4j running in <absolute-path>".
# Adds the analysis workspace name in parentheses if it can be determined from the path.
# Compatible with Linux and macOS. Requires only standard POSIX commands.
# Can be run from any directory – it inspects the process table, not the file system.

# Fail on any error
set -o errexit

# Overrideable Defaults
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Tools directory name used to detect the analysis workspace

# Find any process that contains "neo4j" in its command arguments.
# The bracket pattern '[n]eo4j' prevents grep from matching its own process entry,
# removing the need for a separate 'grep -v grep' step.
_neo4j_cmd=$(ps -eo command 2>/dev/null | grep -i '[n]eo4j' | head -1)

if [ -z "${_neo4j_cmd}" ]; then
    echo "Neo4j not running"
    exit 0
fi

# Extract home from '--home-dir=<path>' command-line argument (Neo4j 5+ / 2025+).
_neo4j_home=$(printf '%s' "${_neo4j_cmd}" \
    | grep -oE '\-\-home-dir=[^[:space:]]+' \
    | head -1 \
    | cut -d= -f2-)

# Fallback: extract home from '-Dneo4j.home=<path>' JVM system property (Neo4j 4 and older).
if [ -z "${_neo4j_home}" ]; then
    _neo4j_home=$(printf '%s' "${_neo4j_cmd}" \
        | grep -oE '\-Dneo4j\.home=[^[:space:]]+' \
        | head -1 \
        | cut -d= -f2-)
fi

# Fallback: derive path from the lib directory in the Java classpath (-cp / -classpath).
# The classpath typically contains an entry like '<neo4j-home>/lib/*'.
if [ -z "${_neo4j_home}" ]; then
    _neo4j_home=$(printf '%s' "${_neo4j_cmd}" \
        | grep -oE '[^[:space:]]+/lib/\*' \
        | head -1 \
        | sed 's|/lib/\*||')
fi

if [ -z "${_neo4j_home}" ]; then
    echo "Neo4j running in (path undetermined)"
    exit 0
fi

# Try to extract the analysis workspace name from the path.
# Pattern: .../temp/<workspace>/<TOOLS_DIRECTORY>/...
_workspace=$(printf '%s' "${_neo4j_home}" \
    | sed -n "s|.*/temp/\([^/]*\)/${TOOLS_DIRECTORY}/.*|\1|p")

if [ -n "${_workspace}" ]; then
    echo "Neo4j running in ${_neo4j_home} (workspace: ${_workspace})"
else
    echo "Neo4j running in ${_neo4j_home}"
fi
