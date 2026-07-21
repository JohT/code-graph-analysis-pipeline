# Plan: Fast SCIP Index Import via `neo4j-admin database import`

**TL;DR**: Speed up initial SCIP index import by running `neo4j-admin database import full` before Neo4j starts (empty-DB guard). A new converter produces the admin-import CSV format with `isTest` and `language` computed in jq. When conditions aren't met (populated DB, `neo4j-admin` missing, v4, unchanged index), the existing LOAD CSV flow runs unchanged.

**Decisions locked**:

- Orchestration: pre-start (before `startNeo4j.sh`) via new script wired into analyze.sh
- Empty-DB detection: `DATA_DIRECTORY/databases/neo4j/` absent or has no files
- `language` property: computed in jq via new `scheme_to_language` function
- `isTest` property: **computed in jq**, included as `isTest:boolean` column in admin CSV — **NO separate Cypher file** (Phase 2 eliminated)
- CSV format: separate script (`convertScipIndexToCsvForNeo4jAdminImport.sh`) — no changes to existing converter
- Node IDs: use `short_symbol` format (3-part: pkg_id version descriptor) — must match existing CSV for edge references
- Database name: hardcoded `neo4j`
- Windows: `scriptExtension=$(ifWindows ".bat" "")` computed after sourcing `operatingSystemFunctions.sh`
- Phase 4 approach: **if-block wrapper** (~6 lines, zero restructuring of `importScipIndexData.sh`)
- Coordination: `SCIP_ADMIN_IMPORT_DONE=true` env variable bridges pre-start and post-start phases

---

## Performance claim — honest assessment

`neo4j-admin import` bypasses the transaction log and writes the native store format at millions of entities per second vs. ~10K–50K/sec for `LOAD CSV`. **The gain is real for large indexes.** But:

- Stop + restart overhead (~30–60 s) would negate the gain for small indexes — this plan avoids it entirely by placing the import before Neo4j starts.
- On repeat runs (index unchanged or database already populated), the fast path is skipped with no regression.
- Constraint creation and enrichment queries still run via Cypher after Neo4j starts (unchanged cost).

**Bottom line**: measurably faster for medium-to-large indexes on first import; neutral for small projects and repeat runs.

---

## Phase 1 — New CSV Conversion Script

**Create**: `domains/scip-index-import/convertScipIndexToCsvForNeo4jAdminImport.sh`

Produces `scip_type_nodes_admin.csv` (internal + external combined) and `scip_type_edges_admin.csv` in `IMPORT_DIRECTORY`.

Node CSV header — camelCase property names; neo4j-admin maps column name → node property:
```
symbol:ID(ScipNode),fqn,name,language,scheme,typeName,file,packageId,packageManager,version,module,isAbstract:boolean,isTest:boolean,:LABEL
```
- `symbol:ID(ScipNode)` — sets both the `symbol` property AND the admin-import ID group
- `fqn` — same value as `symbol` (mirrors `node.fqn = row.symbol` in Cypher import)
- `name` — `display_name` from SCIP (i.e., `short_symbol` descriptor part)
- `language` — computed by new `scheme_to_language` jq function (see below)
- `isAbstract:boolean` — `true` for Interface/AbstractClass/TypeAlias; maps directly
- `isTest:boolean` — **computed from `file` path** (mirrors `Import_SCIP_Type_Internal_Nodes.cypher` exactly); always `false` for external types
- `:LABEL` — `SCIP;SemanticCodeIndexInternalType` for internal, `SCIP;SemanticCodeIndexExternalType` for external

Edge CSV header:
```
:START_ID(ScipNode),:END_ID(ScipNode),:TYPE,referenceCount:int
```

**Node ID format**: uses same `short_symbol` (3-part: pkg_id version descriptor) as existing converter — required for edge references to resolve correctly.

**JQ functions**: define new `JQ_ADMIN_FUNCTIONS` variable copying all functions from `JQ_SHARED_FUNCTIONS`, then add:

```jq
def scheme_to_language(s):
    if   s == "scip-go"         then "Go"
    elif s == "semanticdb"      then "Java"
    elif s == "scip-typescript" then "TypeScript"
    elif s == "rust-analyzer"   then "Rust"
    elif s == "cxx"             then "C++"
    elif s == "scip-ruby"       then "Ruby"
    elif s == "scip-python"     then "Python"
    elif s == "scip-dotnet"     then "C#"
    else s | ltrimstr("scip-") | if length > 0 then (.[0:1] | ascii_upcase) + .[1:] else . end
    end;

def is_test(file):
    (file | contains("/test/")) or (file | contains("/tests/")) or
    (file | contains("/spec/")) or (file | contains("__tests__")) or
    (file | endswith("_test.go")) or (file | contains(".test.")) or
    (file | contains(".spec.")) or (file | contains("\\test\\")) or
    (file | contains("\\tests\\")) or (file | contains("\\spec\\"));
```

**Multi-file merge**: same awk-based deduplication as existing converter (first occurrence wins for nodes; sum `referenceCount:int` for duplicate edges).

**Script structure**: follows `convertScipIndexToCsvForNeo4jImport.sh` exactly — `validate_prerequisites()` → `build_symbol_information_index()` → `extract_type_nodes_admin()` → `extract_external_type_nodes_admin()` → `extract_depends_on_edges_admin()` → per-file loop → `merge_node_csvs_admin()` / `merge_edge_csvs_admin()` → cleanup in `trap ... EXIT`.

---

## Phase 2 — Pre-start Orchestration Script

**Create**: `domains/scip-index-import/importScipIndexDataWithAdminImport.sh`

Called from `analyze.sh` BEFORE `startNeo4j.sh`. Four guards — any failure → silent exit (LOAD CSV fallback):

1. **Indices unchanged?** — call `detectChangedFiles.sh --readonly`. If exit 0 → unchanged, skip.
2. **`neo4j-admin` available?** — check `"${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin${scriptExtension}"` is executable.
3. **Database is empty?** — check `"${DATA_DIRECTORY}/databases/neo4j/"` absent or contains no files.
4. **Neo4j v4?** — extract major version via `cut -d'.' -f1`; if `< 5` → log "Neo4j v4 not supported", skip.

When all guards pass:
1. Call `convertScipIndexToCsvForNeo4jAdminImport.sh` (subprocess for isolation)
2. `mkdir -p "${RUNTIME_DIRECTORY}/logs"` (Neo4j may not have created this yet)
3. Run admin import:
   ```
   NEO4J_HOME=... neo4j-admin${scriptExtension} database import full \
       --path-pattern-style=none \
       --nodes="<absolute-import-dir>/scip_type_nodes_admin.csv" \
       --relationships="<absolute-import-dir>/scip_type_edges_admin.csv" \
       --report-file="${RUNTIME_DIRECTORY}/logs/scip_admin_import.report" \
       neo4j
   ```
   Resolve `IMPORT_DIRECTORY` to absolute path via `cd ... && pwd -P`.
4. `export SCIP_ADMIN_IMPORT_DONE=true`

**Variable defaults the script must define itself** (cannot rely on `configureNeo4j.sh` being sourced on repeat runs):
- `DATA_DIRECTORY=${DATA_DIRECTORY:-"$( pwd -P )/data"}`
- `RUNTIME_DIRECTORY=${RUNTIME_DIRECTORY:-"$( pwd -P )/runtime"}`
- `IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"$( pwd -P )/import"}`
- `NEO4J_EDITION`, `NEO4J_VERSION`, `TOOLS_DIRECTORY` (same defaults as `setupNeo4j.sh`)

**Critical**: Sources `operatingSystemFunctions.sh`, then: `scriptExtension=$(ifWindows ".bat" "")` — `scriptExtension` is NOT a variable in operatingSystemFunctions.sh, must be computed after sourcing.

---

## Phase 3 — Modify `importScipIndexData.sh` (MINIMAL: ~6 lines added)

Add one block immediately after the existing `is_scip_index_change_detected` guard. The block wraps the LOAD-CSV-only steps (CSV conversion + cleanup + LOAD CSV node/edge imports) — leaving the shared enrichment + structure + write-hash tail completely unchanged:

```bash
# Fast path: admin import already populated DB — skip CSV conversion, cleanup, and LOAD CSV
if [[ "${SCIP_ADMIN_IMPORT_DONE:-false}" == "true" ]]; then
    echo "importScipIndexData: Admin import completed. Running constraints and enrichment only."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"
else
    # LOAD CSV path
    ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" bash "${SCIP_INDEX_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jImport.sh" )
    execute_cypher "${IMPORT_QUERIES_DIR}/Cleanup_SCIP_Type_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Internal_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_External_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Edges.cypher"
fi
# -- All existing enrichment + structure + write_scip_index_change_detection_file runs unchanged below --
```

Add `unset SCIP_ADMIN_IMPORT_DONE` at the very end (after `write_scip_index_change_detection_file`).

---

## Phase 4 — Modify `analyze.sh` (SMALL: ~5 lines)

Add between `setupNeo4j.sh` and `startNeo4j.sh` lines, inside the "Setup Tools" log group:

```bash
# Pre-start bulk SCIP import (fast path when DB is empty and neo4j-admin is available)
scip_index_file_prestart=$(find "${INDICES_DIRECTORY}" -maxdepth 1 -name '*.scip.json' -type f 2>/dev/null | head -1 || true)
if [ -n "${scip_index_file_prestart}" ] && [[ ",${ANALYSIS_DOMAINS_TO_SKIP}," != *",scip-index-import,"* ]]; then
    source "${DOMAINS_DIRECTORY}/scip-index-import/importScipIndexDataWithAdminImport.sh"
fi
```

---

## Phase 5 — `testConvertScipIndexToCsvForNeo4jAdminImport.sh` (NEW)

**Create**: `domains/scip-index-import/testConvertScipIndexToCsvForNeo4jAdminImport.sh`

Follows `testConvertScipIndexToCsvForNeo4jImport.sh` exactly (same assertion helpers, same fixtures). Auto-discovered by `runTests.sh` via `find ... -name 'test*.sh'` — no manual registration needed.

Test cases (13 total):

1. Node header contains `symbol:ID(ScipNode)`, `:LABEL`, `language`, `typeName`, `isTest:boolean`
2. Edge header contains `:START_ID(ScipNode)`, `:END_ID(ScipNode)`, `:TYPE`, `referenceCount:int`
3. Internal type row `:LABEL` = `SCIP;SemanticCodeIndexInternalType`
4. External type row `:LABEL` = `SCIP;SemanticCodeIndexExternalType`
5. `scip-typescript` scheme → `language` = `TypeScript`; `semanticdb` → `Java`
6. `fqn` column value equals the `symbol:ID` column value (same short_symbol)
7. Interface/AbstractClass symbol → `isAbstract:boolean` = `true`
8. File containing `/test/` in path → `isTest:boolean` = `true`; non-test file → `false`
9. External type node → `isTest:boolean` = `false`
10. Edge row `:TYPE` = `DEPENDS_ON`, `referenceCount:int` is a valid integer
11. `:START_ID(ScipNode)` values in edge CSV match nodes in node CSV
12. Multi-file merge deduplicates nodes; sums edge `referenceCount:int` across files
13. Missing `INDICES_DIRECTORY` → non-zero exit with clear error

---

## Phase 6 — Documentation

- [domains/scip-index-import/README.md](domains/scip-index-import/README.md) — "Fast Import" section: conditions, fallback behavior, what `SCIP_ADMIN_IMPORT_DONE` does
- [SCRIPTS.md](SCRIPTS.md) — entries for `convertScipIndexToCsvForNeo4jAdminImport.sh` and `importScipIndexDataWithAdminImport.sh`
- [SCIP.md](SCIP.md) — "Performance" note on fast-import path
- [CYPHER.md](CYPHER.md) — **no new entry** (no new Cypher file — `isTest` computed in jq)
- [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) — no new variables

---

### Relevant Files

| File | Role |
|------|------|
| [domains/scip-index-import/convertScipIndexToCsvForNeo4jImport.sh](domains/scip-index-import/convertScipIndexToCsvForNeo4jImport.sh) | Reference for JQ_SHARED_FUNCTIONS, pass structure, merge logic — **do not modify** |
| [domains/scip-index-import/importScipIndexData.sh](domains/scip-index-import/importScipIndexData.sh) | Add if/else block around LOAD CSV steps; add `unset` at end |
| [domains/scip-index-import/queries/import/Import_SCIP_Type_Internal_Nodes.cypher](domains/scip-index-import/queries/import/Import_SCIP_Type_Internal_Nodes.cypher) | Reference for `isTest` path logic and `language` CASE expression |
| [domains/neo4j-management/setupNeo4jInitialPassword.sh](domains/neo4j-management/setupNeo4jInitialPassword.sh) | Reference for `neo4j-admin${scriptExtension}` invocation, `NEO4J_MAJOR_VERSION_NUMBER` extraction |
| [scripts/operatingSystemFunctions.sh](scripts/operatingSystemFunctions.sh) | Source for `ifWindows()`; compute `scriptExtension=$(ifWindows ".bat" "")` after sourcing |
| [scripts/detectChangedFiles.sh](scripts/detectChangedFiles.sh) | Hash-check with `--readonly` flag |
| [scripts/analysis/analyze.sh](scripts/analysis/analyze.sh) | Insert pre-start block after line ~356 (`setupNeo4j.sh`) before line ~361 (`startNeo4j.sh`) |
| [domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh](domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh) | Reference for test structure, assertion helpers, fixture pattern |

---

## Verification

1. `shellcheck domains/scip-index-import/convertScipIndexToCsvForNeo4jAdminImport.sh`
2. `shellcheck domains/scip-index-import/importScipIndexDataWithAdminImport.sh`
3. `bash domains/scip-index-import/testConvertScipIndexToCsvForNeo4jAdminImport.sh` — all 13 cases pass
4. **Fast path integration** (fresh workspace): `analyze.sh --skip-jqassistant --domain scip-index-import --keep-running`
   - `"Admin import completed"` logged pre-Neo4j-start
   - `"Running constraints and enrichment only"` logged post-start
   - `MATCH (n:SemanticCodeIndexInternalType) RETURN count(n)` → non-zero
   - `language`, `isTest`, `isAbstract` properties populated on sampled nodes
5. **LOAD CSV fallback** (populated DB or `neo4j-admin` absent): `analyze.sh --skip-jqassistant --domain scip-index-import --keep-running` → fast path skipped silently, LOAD CSV runs normally
6. **Repeat-run idempotency**: run twice → second run skips admin import (hash unchanged)
7. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/scip-index-import/README.md`

---

## Scope

**Included**: admin-import CSV format, pre-start orchestration, `isTest`+`language` in jq, tests (13 cases), documentation.

**Excluded**: Neo4j v4 support (log and skip gracefully), incremental import (Enterprise-only), `--schema` constraints during import (Enterprise-only), changes to existing LOAD CSV queries.
