#!/usr/bin/env bash

# Detects if Neo4j is running on Windows from WSL or Git Bash.
# Outputs "Neo4j not running" or "Neo4j running in <absolute-path>".
# Adds the analysis workspace name in parentheses if it can be determined from the path.
# Compatible with WSL (Windows Subsystem for Linux) and Git Bash (MSYS2/MINGW).
# Requires Windows PowerShell (powershell.exe) to query Windows processes.
# For Linux or macOS use detectNeo4j.sh instead.

# Fail on any error
set -o errexit

# Overrideable Defaults
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Tools directory name used to detect the analysis workspace

# Detect if running in WSL (Windows Subsystem for Linux)
_is_wsl=false
if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
    _is_wsl=true
fi

# Detect if running in Git Bash (MSYS2/MINGW) or Cygwin
_is_git_bash=false
if [[ "${OSTYPE}" == "msys" ]] || [[ "${OSTYPE}" == "cygwin" ]]; then
    _is_git_bash=true
fi

if [ "${_is_wsl}" = "false" ] && [ "${_is_git_bash}" = "false" ]; then
    echo "detectNeo4j: Error: This script is intended for WSL or Git Bash on Windows."
    echo "detectNeo4j: For Linux or macOS, use detectNeo4j.sh instead."
    exit 1
fi

# Find Windows PowerShell (powershell.exe).
# In WSL it is accessible via Windows interop; in Git Bash via the Windows PATH.
_powershell=""
for _candidate in \
    "powershell.exe" \
    "powershell" \
    "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" \
    "/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"; do
    if command -v "${_candidate}" >/dev/null 2>&1; then
        _powershell="${_candidate}"
        break
    fi
done

if [ -z "${_powershell}" ]; then
    echo "detectNeo4j: Error: Windows PowerShell (powershell.exe) not found."
    if [ "${_is_wsl}" = "true" ]; then
        echo "detectNeo4j: Ensure Windows interop is enabled in WSL (/proc/sys/fs/binfmt_misc/WSLInterop)."
    fi
    exit 1
fi

# Write a temporary PowerShell script to query the Neo4j Windows process.
# Using a heredoc and a temp file avoids the complex inline escaping required by .bat.
_ps_script=$(mktemp /tmp/detectNeo4j_XXXXXX.ps1)

# The first heredoc block uses single quotes ('PWSH') so that the shell does not expand
# anything inside it. TOOLS_DIRECTORY is injected separately via printf afterwards.
cat > "${_ps_script}" << 'PWSH'
$p = (try {
    Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction Stop
} catch {
    Get-WmiObject Win32_Process -Filter "Name='java.exe'" -ErrorAction SilentlyContinue
}) | Where-Object { $_.CommandLine -like '*neo4j*' } | Select-Object -First 1

if (-not $p) { exit }

$cmd = $p.CommandLine
PWSH

# Inject shell variable value as a PowerShell string literal.
# Use a PowerShell single-quoted string and escape embedded single quotes by doubling them.
_tools_directory_ps=${TOOLS_DIRECTORY//\'/\'\'}
printf "\$toolsDir = '%s'\n" "${_tools_directory_ps}" >> "${_ps_script}"

cat >> "${_ps_script}" << 'PWSH'
# Extract the Neo4j home path: try three strategies in priority order
$neo4jHome = ''
if ($cmd -match '--home-dir=(\S+)')                           { $neo4jHome = $Matches[1] }
if (-not $neo4jHome -and $cmd -match '-Dneo4j\.home=(\S+)')  { $neo4jHome = $Matches[1] }
if (-not $neo4jHome -and $cmd -match '([^;]+)\\lib\\\*')     { $neo4jHome = $Matches[1] }
if (-not $neo4jHome) { Write-Output '__UNKNOWN__|'; exit }

# Try to extract the analysis workspace name from the path.
# Pattern (backslashes): ...\temp\<workspace>\<toolsDir>\...
# Pattern (forward slashes, edge cases): .../temp/<workspace>/<toolsDir>/...
$workspace = ''
if ($neo4jHome -match '\\temp\\([^\\]+)\\' + $toolsDir + '\\') { $workspace = $Matches[1] }
if (-not $workspace -and $neo4jHome -match '/temp/([^/]+)/' + $toolsDir + '/') { $workspace = $Matches[1] }

Write-Output "$neo4jHome|$workspace"
PWSH

# Execute the PowerShell script and capture output.
# "|| true" prevents set -e from aborting when PowerShell exits with a non-zero code.
_result=$(${_powershell} -NoProfile -ExecutionPolicy Bypass -File "${_ps_script}" 2>/dev/null || true)

# Remove the temporary PowerShell script
rm -f "${_ps_script}"

# Strip Windows carriage returns (\r) that powershell.exe may add in WSL
_result=$(printf '%s' "${_result}" | tr -d '\r')

# Split the pipe-separated result into home path and workspace name.
# IFS='|' read assigns everything before the first '|' to _neo4j_home,
# and the remainder to _workspace (empty string when not found).
IFS='|' read -r _neo4j_home _workspace <<< "${_result}"

if [ -z "${_neo4j_home}" ]; then
    echo "Neo4j not running"
    exit 0
fi

if [ "${_neo4j_home}" = "__UNKNOWN__" ]; then
    echo "Neo4j running in (path undetermined)"
    exit 0
fi

# Convert Windows backslashes to forward slashes for readability in a Unix shell context
_neo4j_home_display=$(printf '%s' "${_neo4j_home}" | tr '\\' '/')

if [ -n "${_workspace}" ]; then
    echo "Neo4j running in ${_neo4j_home_display} (workspace: ${_workspace})"
else
    echo "Neo4j running in ${_neo4j_home_display}"
fi
