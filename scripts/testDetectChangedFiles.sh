#!/usr/bin/env bash

# Tests "detectChangedFiles.sh".

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "testDetectChangedFiles: SCRIPTS_DIR=${SCRIPTS_DIR}" >&2

tearDown() {
  # echo "testDetectChangedFiles: Tear down tests...."
  rm -rf "${temporaryTestDirectory}"
}

successful() {
  local COLOR_SUCCESSFUL="\033[0;32m" # green 
  local COLOR_DEFAULT='\033[0m'

  echo -e "testDetectChangedFiles: ${COLOR_SUCCESSFUL}Tests finished successfully.${COLOR_DEFAULT}"

  tearDown
  exit 0
}

fail() {
  local COLOR_ERROR='\033[0;31m' # red
  local COLOR_DEFAULT='\033[0m'

  local errorMessage="${1}"

  echo -e "testDetectChangedFiles: ${COLOR_ERROR}${errorMessage}${COLOR_DEFAULT}"
  tearDown
  exit 1
}

echo "testDetectChangedFiles: Starting tests...."

# Create testing resources
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t 'temporaryTestDirectory')
testHashFile="${temporaryTestDirectory}/testHashFile.sha"
testFileForChangeDetection="${temporaryTestDirectory}/testFileForChangeDetection.txt"
echo "Some Test Content" > "${testFileForChangeDetection}"

# Test cases
echo "testDetectChangedFiles: 1.) Create missing hashfile and report that as changed file."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}")
if [ "${changeDetectionReturnCode}" != "1" ]; then
  fail "1.) Test failed: Expected return code 1 for non existing hash file (change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 2.) Detect an unchanged file when the hashfile contains the same value as the newly calculated one."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}")
if [ "${changeDetectionReturnCode}" != "0" ]; then
  fail "2.) Tests failed: Expected return code 0 for an existing hash file with matching value (no change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 3.) Detect a changed file when the hashfile contains a different value as the current one."
echo "Some CHANGED Test Content" > "${testFileForChangeDetection}"
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}")
if [ "${changeDetectionReturnCode}" != "2" ]; then
  fail "3.) Tests failed: Expected return code 2 for an existing hash file with differing value (change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 4.) Detect an unchanged file when the hashfile contains the same value as the current one again. Same as 2.) but different after 3.)."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}")
if [ "${changeDetectionReturnCode}" != "0" ]; then
  fail "4.) Tests failed: Expected return code 0 for an existing hash file with matching value (no change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 5.) Detect a changed directory when the hashfile contains a different value as the current one."
echo "Some CHANGED Test Directory Content" > "${testFileForChangeDetection}"
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${temporaryTestDirectory}")
if [ "${changeDetectionReturnCode}" != "2" ]; then
  fail "5.) Tests failed: Expected return code 2 for an existing hash file with differing value (change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 6.) Detect an unchanged directory when the hashfile contains the same value as the newly calculated one."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${temporaryTestDirectory}")
if [ "${changeDetectionReturnCode}" != "0" ]; then
  fail "6.) Tests failed: Expected return code 0 for an existing hash file with matching value (no change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 7.) Detect a changed file when the hashfile contains a different value as the current one in read-only mode."
echo "Some CHANGED AGAIN Test Content" > "${testFileForChangeDetection}"
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}" --readonly)
if [ "${changeDetectionReturnCode}" != "2" ]; then
  fail "7.) Tests failed: Expected return code 2 for an existing hash file with differing value (change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 8.) Detect a changed file when the hashfile hadn't been update with the last change detection in read-only mode."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection}" --readonly)
if [ "${changeDetectionReturnCode}" != "2" ]; then
  fail "8.) Tests failed: Expected return code 2 for an existing hash file with differing value (change detected), but got ${changeDetectionReturnCode}."
fi

echo "testDetectChangedFiles: 9.) Fail on not existing first path"
if changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "./nonExistingFile.txt,${testFileForChangeDetection}"); then
  fail "9.) Tests failed: Expected to fail due to a wrong paths option, but got ${changeDetectionReturnCode}."
fi

testCaseNumber=$((testCaseNumber + 1))
echo "testDetectChangedFiles: 10.) Fail on not existing second path"
if changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "${testFileForChangeDetection},./nonExistingFile2.txt"); then
  fail "10.) Tests failed: Expected to fail due to a wrong paths option, but got ${changeDetectionReturnCode}."
fi

testCaseNumber=$((testCaseNumber + 1))
echo "testDetectChangedFiles: 11.) Interpret missing paths as 'nothing changed'."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "")
if [ "${changeDetectionReturnCode}" != "0" ]; then
  fail "11.) Tests failed: Expected return code 0 if there are no paths to check, but got ${changeDetectionReturnCode}."
fi

testCaseNumber=$((testCaseNumber + 1))
echo "testDetectChangedFiles: 12.) Fail on not unknown command-line option"
if changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "./nonExistingFile.txt,${testFileForChangeDetection}" --unknown); then
  fail "12.) Tests failed: Expected to fail due to a an unknown command-line option, but got ${changeDetectionReturnCode}."
fi

testCaseNumber=$((testCaseNumber + 1))
echo "testDetectChangedFiles: 13.) Ignore protocol prefix in file path like 'typescript:project::./myfile.txt'."
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${testHashFile}" --paths "typescript:project::${testFileForChangeDetection}")
if [ "${changeDetectionReturnCode}" = "0" ]; then
  fail "13.) Tests failed: Expected return code 0 if nothing changed with a protocol prefixed file, but got ${changeDetectionReturnCode}."
fi

successful