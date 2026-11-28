#!/usr/bin/env bash

# Clears the "password expired" security flag on a Neo4j database after initial password setup.
# 
# When neo4j-admin dbms set-initial-password is used (e.g., after admin import), the password
# is marked as "expired" for security reasons. This flag must be cleared before queries can run.
# This requires Neo4j to be running and executes: ALTER CURRENT USER SET PASSWORD FROM 'pwd' TO 'pwd'
#
# Prerequisites:
#   - NEO4J_INITIAL_PASSWORD must be set
#   - NEO4J_HTTP_PORT must be set (or defaults to 7474)
#   - Neo4j must be running and HTTP API must be accessible
#
# Returns:
#   0 if password expiration flag cleared or already not expired
#   1 if unable to clear the flag
#
# Design: Custom Curl Approach
#   This script uses custom curl + jq instead of central executeQueryFunctions.sh because:
#   1. Specialized retry logic (30 attempts) for password clearing only
#   2. Specialized error detection: "password is not expired" (idempotence)
#   3. Early pipeline stage with different auth context (NEO4J_INITIAL_PASSWORD)
#   4. Avoids modifying central query infrastructure used by 100+ other queries
#   5. Direct exit codes for clean composition with parent scripts
#
# Retry Strategy Rationale:
#   30 attempts with 1-second backoff (~30 seconds total) accounts for:
#   - Transient connection issues after admin import
#   - Database stabilization delays even when "started in" message received
#   - Variable system performance (especially in containers/CI environments)
#   - Graceful fallback: If password flag can't be cleared here, it's cleared on first query

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "clearNeo4jPasswordExpiration: Error: NEO4J_INITIAL_PASSWORD not set" >&2
    exit 1
fi

echo "clearNeo4jPasswordExpiration: Clearing password expiration flag..."

# Escape single quotes in password for use in Cypher string literals
# shellcheck disable=SC1003
escaped_password="${NEO4J_INITIAL_PASSWORD//\'/\'\'}"

# Build the ALTER CURRENT USER command to clear the expired flag
alter_password_query="ALTER CURRENT USER SET PASSWORD FROM '${escaped_password}' TO '${escaped_password}';"

# Retry loop to clear the expired password flag.
# 30 attempts with 1-second backoff (~30 seconds total) accounts for transient issues,
# database stabilization delays, and variable system performance in diverse environments.
# If clearing fails here, the flag is cleared on first actual query attempt.
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    attempt=$((attempt + 1))
    
    # Try to execute the ALTER CURRENT USER command
    cypher_query=$(echo -n "${alter_password_query}" | jq -Rsa . 2>/dev/null || echo "null")
    if [ "$cypher_query" = "null" ]; then
        echo "clearNeo4jPasswordExpiration: Error: jq not available for password clearing" >&2
        exit 1
    fi
    
    cypher_query_for_api="{\"statements\":[{\"statement\":${cypher_query},\"parameters\":{},\"includeStats\": false}]}"
    
    if curl_result=$(curl --silent -S --fail-with-body -H Accept:application/json -H Content-Type:application/json \
         -u neo4j:"${NEO4J_INITIAL_PASSWORD}" \
         "http://localhost:${NEO4J_HTTP_PORT}/db/neo4j/tx/commit" \
         -d "${cypher_query_for_api}" 2>&1);
    then
        # Check if there's an error in the response
        error_message=$( echo "${curl_result}" | jq -r '.errors[0].message // empty' 2>/dev/null || true )
        if [[ -z "${error_message}" ]]; then
            echo "clearNeo4jPasswordExpiration: Password expiration flag cleared successfully"
            exit 0
        elif [[ "${error_message}" == *"password is not expired"* ]]; then
            echo "clearNeo4jPasswordExpiration: Password is not expired (already cleared)"
            exit 0
        fi
        # If error message exists but not "already cleared", retry
    fi
    
    # Wait before retrying
    if [ $attempt -lt $max_attempts ]; then
        sleep 1
    fi
done

echo "clearNeo4jPasswordExpiration: Error: Could not clear password expiration flag after ${max_attempts} attempts" >&2
exit 1
