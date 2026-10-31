#!/usr/bin/env bash

# Unit tests for installScipJava.sh.
# Tests: --help exit 0, unknown argument exit non-zero, --bin-dir respected, idempotency (no network).

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

SCRIPT_DIR=$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )
readonly INSTALL_SCRIPT="${SCRIPT_DIR}/installScipJava.sh"

passed=0
failed=0

function pass() {
    local test_name="${1}"
    echo "${SCRIPT_NAME}: PASS: ${test_name}"
    passed=$(( passed + 1 ))
}

function fail() {
    local test_name="${1}"
    local reason="${2}"
    echo "${SCRIPT_NAME}: FAIL: ${test_name}: ${reason}" >&2
    failed=$(( failed + 1 ))
}

function test_help_exits_zero() {
    if "${INSTALL_SCRIPT}" --help >/dev/null 2>&1; then
        pass "--help exits 0"
    else
        fail "--help exits 0" "expected exit code 0, got non-zero"
    fi
}

function test_help_prints_usage() {
    local output
    output=$("${INSTALL_SCRIPT}" --help 2>&1 || true)
    if echo "${output}" | grep -q "Usage:"; then
        pass "--help prints usage"
    else
        fail "--help prints usage" "expected 'Usage:' in output"
    fi
}

function test_unknown_argument_exits_nonzero() {
    if "${INSTALL_SCRIPT}" --unknown-flag >/dev/null 2>&1; then
        fail "unknown argument exits non-zero" "expected non-zero exit code, got 0"
    else
        pass "unknown argument exits non-zero"
    fi
}

function test_unknown_argument_prints_error() {
    local output
    output=$("${INSTALL_SCRIPT}" --unknown-flag 2>&1 || true)
    if echo "${output}" | grep -qi "unknown\|error"; then
        pass "unknown argument prints error message"
    else
        fail "unknown argument prints error message" "expected error message in output"
    fi
}

function test_bin_dir_argument_is_respected() {
    local tmp_dir
    tmp_dir=$(mktemp -d)
    # shellcheck disable=SC2064
    trap "rm -rf '${tmp_dir}'" EXIT

    local fake_binary="${tmp_dir}/scip-java"
    echo "#!/bin/sh" > "${fake_binary}"
    chmod +x "${fake_binary}"

    local install_output
    install_output=$("${INSTALL_SCRIPT}" --bin-dir "${tmp_dir}" 2>&1 || true)

    if echo "${install_output}" | grep -q "Skipping"; then
        pass "--bin-dir: existing binary detected and install skipped"
    else
        fail "--bin-dir: existing binary detected and install skipped" "expected 'Skipping' in output; got: ${install_output}"
    fi

    trap - EXIT
    rm -rf "${tmp_dir}"
}

function test_idempotency_skips_install_when_binary_exists() {
    local tmp_dir
    tmp_dir=$(mktemp -d)
    # shellcheck disable=SC2064
    trap "rm -rf '${tmp_dir}'" EXIT

    local fake_binary="${tmp_dir}/scip-java"
    printf '#!/bin/sh\necho "fake scip-java"\n' > "${fake_binary}"
    chmod +x "${fake_binary}"

    local install_output
    install_output=$("${INSTALL_SCRIPT}" --bin-dir "${tmp_dir}" 2>&1 || true)

    if echo "${install_output}" | grep -q "Skipping"; then
        pass "idempotency: install skipped when binary already exists"
    else
        fail "idempotency: install skipped when binary already exists" "expected 'Skipping'; got: ${install_output}"
    fi

    # Verify no network access was attempted (fake binary should still be our stub)
    if [ -f "${fake_binary}" ] && grep -q "fake scip-java" "${fake_binary}"; then
        pass "idempotency: original binary not overwritten"
    else
        fail "idempotency: original binary not overwritten" "binary was replaced"
    fi

    trap - EXIT
    rm -rf "${tmp_dir}"
}

echo "${SCRIPT_NAME}: Running tests for installScipJava.sh..."
test_help_exits_zero
test_help_prints_usage
test_unknown_argument_exits_nonzero
test_unknown_argument_prints_error
test_bin_dir_argument_is_respected
test_idempotency_skips_install_when_binary_exists

echo ""
echo "${SCRIPT_NAME}: Results: ${passed} passed, ${failed} failed"

if [ "${failed}" -gt 0 ]; then
    exit 1
fi
