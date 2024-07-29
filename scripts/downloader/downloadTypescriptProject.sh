#!/usr/bin/env bash

# Downloads the given version of a Typescript project from a git repository using git clone.
# The cloned project is then moved into the "source" directory of the current analysis directory 
# where its dependencies are installed by the given package manager.
# After scanning it with jQAssistant's Typescript Plugin, the resulting JSON will be moved into the "artifacts/typescript" directory.

# Command line options:
# --url             Git clone URL (optional, default = skip clone)
# --version         Version of the project
# --tag             Tag to switch to after "git clone" (optional, default = version)
# --project         Name of the project/repository (optional, default = clone url file name without .git extension)
# --packageManager  One of "npm", "pnpm" or "yarn". (optional, default = "npm")

# Note: This script is meant to be started within the temporary analysis directory (e.g. "temp/AnalysisName/")

# Fail on any error (errexit = exit on first error, errtrace = error inherited from sub-shell ,pipefail exist on errors within piped commands)
set -o errexit -o errtrace -o pipefail

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}
echo "downloadTypescriptProject: SOURCE_DIRECTORY=${SOURCE_DIRECTORY}"

# Display how this command is intended to be used including an example when wrong input parameters were detected
usage() {
  echo ""
  echo "Usage: $0 \\"
  echo "          --version <project version \\"
  echo "          [ --tag <git-tag-for-that-version> (default=version) \\]"
  echo "          [ --url <git-clone-url> (default=skip clone)] \\"
  echo "          [ --project <name-of-the-project> (default=url file name) \\]"
  echo "          [ --packageManager <npm/pnpm/yarn> (default=npm) ]"
  echo "Example: $0 \\"
  echo "           --url https://github.com/ant-design/ant-design.git \\"
  echo "           --version 5.19.3"
  exit 1
}

# Default command line option values
cloneUrl=""
projectName=""
projectVersion=""
projectTag=""
packageManager="npm"

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="${1}"
  value="${2}"

  case "${key}" in
    --url)
      cloneUrl="${value}"
      shift
      ;;
    --project)
      projectName="${value}"
      shift
      ;;
    --version)
      projectVersion="${value}"
      shift
      ;;
    --tag)
      projectTag="${value}"
      shift
      ;;
    --packageManager)
      packageManager="${value}"
      shift
      ;;
    *)
      echo "downloadTypescriptProject Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift
done

if [ -n "${cloneUrl}" ]; then
  # url specified -> check if valid
  if ! curl --head --fail "${cloneUrl}" >/dev/null 2>&1; then
    echo "downloadTypescriptProject Error: Invalid URL: ${cloneUrl}"
    exit 1
  fi
else
    # url not specified -> check if at least project name specified
  if [ -z "${projectName}" ]; then
    echo "downloadTypescriptProject Error: Please specify either an URL or a project name."
    usage
  fi
fi

if [ -z "${projectName}" ]; then
  # When empty, infer the project name from the file name / last part of the clone url excluding the extension .git
  projectName=$(basename -s .git "${cloneUrl}")
  echo "downloadTypescriptProject Using ${projectName} as project name from the URL since not specified otherwise."
fi

if [ -z "${projectVersion}" ]; then
  echo "downloadTypescriptProject Error: Please specify a project version."
  usage
fi

if [ -z "${projectTag}" ]; then
  # When empty, use the value of the option "version" as tag
  echo "downloadTypescriptProject Using ${projectVersion} as project tag since not specified otherwise."
  projectTag="${projectVersion}"
fi

case "${packageManager}" in
  npm|pnpm|yarn) 
    echo "downloadTypescriptProject Using package manager ${packageManager}" 
    ;;
  *)
    echo "downloadTypescriptProject Error: Unknown package manager: ${packageManager}"
    usage
    ;;
esac

if ! command -v "${packageManager}" &> /dev/null ; then
    echo "downloadTypescriptProject Error: Package manager ${packageManager} could not be found"
    exit 1
fi

if ! command -v "npx" &> /dev/null ; then
    echo "downloadTypescriptProject Error: Command npx not found. It's needed to execute npm packages."
    exit 1
fi

echo "downloadTypescriptProject: cloneUrl:       ${cloneUrl}"
echo "downloadTypescriptProject: projectName:    ${projectName}"
echo "downloadTypescriptProject: projectVersion: ${projectVersion}"
echo "downloadTypescriptProject: projectTag:     ${projectTag}"
echo "downloadTypescriptProject: packageManager: ${packageManager}"

usePackageManagerToInstallDependencies() {
  echo "downloadTypescriptProject: Installing dependencies using ${packageManager}..."
  case "${packageManager}" in
    npm)
      # npm ci is not sufficient for projects like "ant-design" that rely on generating the package-lock
      # Even if this is not standard, this is an acceptable solution for standard and edge cases.
      npm install --ignore-scripts --verbose || exit
      ;;
    pnpm)
      pnpm install --frozen-lockfile || exit
      ;;
    yarn)
      yarn install --frozen-lockfile --ignore-scripts --non-interactive --verbose || exit
      ;;
  esac
}

# Create runtime logs directory if it hasn't existed yet
mkdir -p ./runtime/logs

# Download the project to be analyzed
fullProjectName="${projectName}-${projectVersion}"
fullSourceDirectory="${SOURCE_DIRECTORY}/${fullProjectName}"

if [ ! -d "${fullSourceDirectory}" ]; then # source doesn't exist
  if [ -n "${cloneUrl}" ]; then # only clone if url is specified and source doesn't exist 
    echo "downloadTypescriptProject: Cloning ${cloneUrl} with version ${projectVersion}..."
    # A full clone is done since not only the source is scanned, but also the git log/history.
    git clone --branch "${projectTag}" "${cloneUrl}" "${fullSourceDirectory}"
  else
    # Source doesn't exist and no clone URL is specified.
    echo "downloadTypescriptProject: Error: Source directory ${fullSourceDirectory} for project ${projectName} not found."
    exit 1
  fi
else
  # Source already exists. Cloning not necessary.
  echo "downloadTypescriptProject: Source already exists. Skip cloning ${cloneUrl}"
fi

(
  cd "${fullSourceDirectory}" || exit
  usePackageManagerToInstallDependencies
  echo "downloadTypescriptProject: Scanning Typescript source using @jqassistant/ts-lce..."
  npx --yes @jqassistant/ts-lce@1.2.0 >"./../../runtime/logs/jqassistant-typescript-scan-${projectName}.log" 2>&1 || exit
)
echo "downloadTypescriptProject: Moving scanned results into the artifacts/typescript directory..."
mkdir -p artifacts/typescript
mv -nv "${fullSourceDirectory}/.reports/jqa/ts-output.json" "artifacts/typescript/${fullProjectName}.json"