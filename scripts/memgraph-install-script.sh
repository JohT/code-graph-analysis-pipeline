#!/bin/sh -eu
# Downloaded with curl from https://install.memgraph.com

OS=$(uname -s)
ARCH=$(uname -m)

CHECK_UNICODE="\xE2\x9C\x94"
FAIL_UNICODE="\033[1mx\033[0m"

if [ "${OS}" = "Linux" ]
then
  CMD_PREFIX="/bin/"
elif [ "${OS}" = "Darwin" ]
then
  CMD_PREFIX=""
else
  CMD_PREFIX=""
fi

msg_out() {
  ${CMD_PREFIX}echo -e "$1"
}

err_out() {
  msg_out "$(bold "ERROR"): $1" >&2
  exit 1
}

bold() {
  msg_out "\033[1m${1}\033[0m"
}

check_cmd_dep() {
  local check_cmd="command -V ${CMD_PREFIX}$1"
  if [ "$1" = "docker compose" ]; then
    check_cmd="${CMD_PREFIX}docker compose version"
  fi
  if $check_cmd > /dev/null 2>&1; then
    msg_out "$1 $CHECK_UNICODE"
    return 0
  else
    msg_out "$1 $(bold "x")"
    $check_cmd
    return 1
  fi
}

# Check required commands
msg_out "$(bold "Checking for requirements on this machine:")"
check_deps=1
if check_cmd_dep "curl"; then
  _download_cmd=curl
elif check_cmd_dep "wget"; then
  _download_cmd=wget
else
  check_deps=0
  eerr_out "you need to have 'curl' or 'wget' installed"
fi
check_cmd_dep "docker" || check_deps=0
check_cmd_dep "docker compose" || check_deps=0
check_cmd_dep "mkdir" || check_deps=0
check_cmd_dep "pwd" || check_deps=0
if [ "$check_deps" -eq 0 ]; then
  err_out "All requirements must be satisfied to run this script!"
fi

DIR=$(${CMD_PREFIX}pwd)
MGPLAT_DIR="$DIR/memgraph-platform"
MGPLAT_COMPOSE_PATH="$MGPLAT_DIR/docker-compose.yml"
DOCKER_COMPOSE_URL="https://raw.githubusercontent.com/memgraph/memgraph-platform/main/docker-compose.yml"

# Check if compose file already exists
if [ -f "$MGPLAT_COMPOSE_PATH" ]; then
  msg_out "\n$(bold "Overwriting docker compose file found at:") $MGPLAT_COMPOSE_PATH"
elif [ ! -d $MGPLAT_DIR ]; then
  ${CMD_PREFIX}mkdir -p $MGPLAT_DIR
fi

# Download compose file
msg_out "\n$(bold "Downloading docker compose file to:") $MGPLAT_COMPOSE_PATH"
${CMD_PREFIX}$_download_cmd $DOCKER_COMPOSE_URL -o "$MGPLAT_DIR/docker-compose.yml" || \
err_out "Something went wrong when dowloading docker-compose.yml from $DOCKER_COMPOSE_URL"

# Run compose
cd $MGPLAT_DIR
msg_out "\n$(bold "Spinning up memgraph lab and memgraph with mage using docker compose file from:") $MGPLAT_COMPOSE_PATH"
${CMD_PREFIX}docker compose up
