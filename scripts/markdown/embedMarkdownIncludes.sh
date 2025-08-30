#!/usr/bin/env bash

# Processes a template_markdown_file markdown file, replacing placeholders like "<!-- include:intro.md -->" with the contents of the specified markdown files. The files to include needs to be in the "includes" subdirectory.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
#echo "embedMarkdownIncludes: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

template_markdown_file="$1"
include_directory="includes"

awk -v include_directory="${include_directory}" '
  # Check if the filename is safe
  function is_safe(path) {
    if (substr(path, 1, 1) == "/") return 0
    if (path ~ /\.\./) return 0
    return 1
  }

  function include_file(path,   fullpath, line) {
    fullpath = include_directory "/" path

    if (!is_safe(path)) {
      print "ERROR: illegal include path: " path > "/dev/stderr"
      exit 1
    }

    if ((getline test < fullpath) < 0) {
      print "ERROR: missing file " fullpath > "/dev/stderr"
      exit 1
    }
    close(fullpath)

    while ((getline line < fullpath) > 0) {
      print line
    }
    close(fullpath)
  }

  {
    # Look for the include marker using index+substr (portable)
    if ($0 ~ /<!-- include:/) {
      start = index($0, "include:") + 8
      end   = index($0, "-->")
      fname = substr($0, start, end - start)
      gsub(/^[ \t]+|[ \t]+$/, "", fname)   # trim spaces

      include_file(fname)
    } else {
      print
    }
  }
' "${template_markdown_file}"

#echo "embedMarkdownIncludes: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished." >&2