#!/usr/bin/env bash
# Deprecated: stopNeo4j.sh has been moved to domains/neo4j-management/.
# This stub exists for backward compatibility only — it forwards all arguments to the domain implementation.
# New code should reference domains/neo4j-management/stopNeo4j.sh directly.
source "$(dirname -- "${BASH_SOURCE[0]}")/../domains/neo4j-management/stopNeo4j.sh" "${@}"
