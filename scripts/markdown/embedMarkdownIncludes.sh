#!/usr/bin/env bash

# Processes template markdown (sysin) replacing placeholders like "<!-- include:intro.md -->" or "<!-- include:intro.md|fallback.md -->" with the contents of the specified markdown files. The files to include needs to be in the "includes" subdirectory.
# Can take an optional input for the directory that contains the markdown files to be included/embedded (defaults to "includes").

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts for markdown
#echo "embedMarkdownIncludes: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

# Read all input (including multiline) into markdown_template
markdown_template=$(cat)

includes_directory="$1"
if [ -z "${includes_directory}" ] ; then
  includes_directory="./includes"
  echo "embedMarkdownIncludes: Using default include directory ${includes_directory}." >&2
fi
if [ ! -d "${includes_directory}" ] ; then
  echo "embedMarkdownIncludes: Couldn't find include directory ${includes_directory}." >&2
  exit 2
fi

echo -n "${markdown_template}" | awk -v includes_directory="${includes_directory}" '
  # Check if the filename is safe
  function is_safe(path) {
    if (substr(path, 1, 1) == "/") return 0
    if (path ~ /\.\./) return 0
    return 1
  }

  function try_include(path,   fullpath, line) {
    if (!is_safe(path)) {
      print "ERROR: illegal include path: " path > "/dev/stderr"
      exit 1
    }
    fullpath = includes_directory "/" path
    if ((getline test < fullpath) < 0) {
      return 0  # not found
    }
    close(fullpath)

    while ((getline line < fullpath) > 0) {
      print line
    }
    close(fullpath)
    return 1
  }

  function include_file(spec,   n, parts, i, success) {
    n = split(spec, parts, /\|/)
    success = 0
    for (i = 1; i <= n; i++) {
      gsub(/^[ \t]+|[ \t]+$/, "", parts[i])   # trim
      if (parts[i] == "") continue
      if (try_include(parts[i])) {
        success = 1
        break
      }
    }
    if (!success) {
      print "ERROR: missing include file(s): " spec > "/dev/stderr"
      exit 1
    }
  }

  {
    # Look for the include marker
    if ($0 ~ /<!--[ \t]*include:/) {
      start = index($0, "include:") + 8
      end   = index($0, "-->")
      fname = substr($0, start, end - start)
      gsub(/^[ \t]+|[ \t]+$/, "", fname)

      include_file(fname)
    } else {
      print
    }
  }
'


#echo "embedMarkdownIncludes: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished." >&2