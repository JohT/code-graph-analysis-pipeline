# Plan: Full Git Log Import Multi-Pass Optimization (REVISED with PROFILE data)

**STATUS: ✅ IMPLEMENTATION COMPLETE** (as of 2026-10-10)

**Plan corrections applied during implementation:**
1. **Pass 3 now mandatory** — original plan marked it "optional", but it eliminates ~3.15M DB accesses (38% of bottleneck)
2. **HAS_FILE, HAS_COMMIT, HAS_AUTHOR moved to Pass 3** — original plan suggested incoherent "pre-create single HAS_FILE in Pass 1"; corrected to deduplicate once per unique node in Pass 3
3. **Assertion query added** — validates Pass 1 completeness before starting Pass 2; prevents silent data loss if import is interrupted
4. **gitLog.csv stripped (lean schema)** — removed commit metadata; separate gitLogCommits.csv carries commit+author data (breaking change, intentional)

---

**CRITICAL UPDATE from PROFILE analysis:**

The actual bottleneck is **relationship lookup overhead** (8.2M total DB accesses), not datetime parsing. The two-pass approach still helps, but for the correct reason.

---

## Actual Bottleneck (from PROFILE)

**Total DB accesses: 8,243,937** — far exceeding what datetime parsing could account for.

**Expand(Into) relationship lookups are the killer:**
- Op 29: `(git_repository)-[:HAS_COMMIT]->`: 1,183,984 DB Hits
- Op 34: `(git_commit)-[:CONTAINS_CHANGED]->`: 1,603,442 DB Hits
- Op 38: `(git_author)-[:AUTHORED]->`: 1,221,806 DB Hits
- Op 25: `(git_repository)-[:HAS_AUTHOR]->`: 590,910 DB Hits
- Op 21: `(git_repository)-[:HAS_FILE]->`: 1,382,371 DB Hits
- Op 11: `(old_git_file)-[:HAS_NEW_NAME]->`: 131,113 DB Hits
- Op 7: `(git_repository)-[:HAS_FILE]->` (rename): 130,437 DB Hits
- **Subtotal from relationships: ~6.1M DB Hits**

**Why this happens:**
- Every `MERGE (a)-[:REL]->(b)` first checks: does this relationship already exist?
- This requires scanning the relationship graph to answer the existence question
- With 92,300 CSV rows and 7 relationship MERGEs per row = ~646k relationship checks
- No index on relationships → full relationship scans per check

**What's NOT the bottleneck:**
- Datetime parsing (included in ON CREATE SET, not shown as separate operator)
- Index label mismatches (indexes are used correctly on single labels :Author, :Commit, :File)
- Page cache (12.8M hits, 0 misses — all data in memory)
- Transaction batching (1000 rows per batch is reasonable)

---

## Why Two-Pass Helps (Corrected Understanding)

**Single-pass (current):** 92,300 rows × 7 MERGE relationships = 646k+ relationship existence checks simultaneously

**Two-pass:**
- **Pass 1:** 13,750 rows × 0 MERGE relationships (only node creation) = 0 relationship checks
- **Pass 2:** 17,484 rows × 4-5 MERGE relationships (commit→file, author→commit, renames/deletes, no repo→author/commit/file checks since those already exist) = ~80k relationship checks
- **Result:** ~566k fewer relationship lookups, and relationships created in pass 1 are already cached when pass 2 runs

---

## Updated Plan: Two-Pass Import with Node-First Strategy

### Phase 1 — Separate CSV generation (`createGitLogData.sh`)

1. Add a second `git log` run:
   - New: `git log --format='%H,,,%P,,,%an,,,%ae,,,%ct,,,%s' | awk ...` → `gitLogCommits.csv` with schema `hash,parent,author,email,timestamp_unix,message`
     - **One row per unique commit** (13,750 for AxonFramework, not 17,484)
   - Existing: `git log --format='%H' --name-status | awk ...` → `gitLog.csv` simplified to `hash,filename,change_type,old_filename`
     - Commit metadata dropped from each row
2. Both CSVs written in one `createGitLogData.sh` invocation

### Phase 2 — Cypher Files (replaces the current single import) — ✅ IMPLEMENTED

**Pass 1: Create all nodes** (reads `gitLogCommits.csv`)
- `Import_git_log_nodes_csv_data.cypher`
  - MERGE `Git:Log:Author {name, email}` — **0 relationship checks**
  - MERGE `Git:Log:Commit {hash}` ON CREATE SET timestamp properties using `datetime({epochSeconds: toInteger(row.timestamp_unix)})` — **0 relationship checks**
  - MERGE `(author)-[:AUTHORED]->(commit)` — **1 relationship check per unique commit**
  - Result: Only 13,750 rows, ~13,750 relationship checks (vs. 92,300 × 1 = 92,300 in single pass)
  - `IN TRANSACTIONS OF 500 ROWS`

**Pass 1→2 Assertion: Verify import completeness** (NEW)
- `Verify_git_log_commits_imported.cypher` (in `queries/validation/`)
  - Loads `gitLogCommits.csv` again, counts missing commits from database
  - Fails import if any commit is missing — prevents silent data loss in Pass 2

**Pass 2: Create file nodes and change relationships** (reads `gitLog.csv`)
- `Import_git_log_relationships_csv_data.cypher`
  - **MATCH** `Git:Log:Commit {hash}` — not MERGE, nodes cached from Pass 1
  - MERGE `Git:Log:File {fileName, repositoryPath}` — **~17,484 relationship checks**
  - MERGE `(commit)-[:CONTAINS_CHANGED]->(file)` — **~92,300 relationship checks** (one per CSV row, but commit already exists)
  - FOREACH rename: MERGE old_file, create HAS_NEW_NAME relationship
  - FOREACH delete: SET git_file.deletedAt
  - **HAS_FILE, HAS_COMMIT, HAS_AUTHOR removed** (moved to Pass 3)
  - `IN TRANSACTIONS OF 500 ROWS`

**Pass 3 (MANDATORY): Repository-level relationships** — ✅ IMPLEMENTED (3 separate queries)
- Run ONCE after all files imported, scoped by repositoryPath to each repository
- `Create_git_log_repo_commit_relationships.cypher`
  - MATCH (repo), query for distinct commits via CONTAINS_CHANGED+repositoryPath
  - MERGE (repo)-[:HAS_COMMIT]->(commit) once per unique commit (not per CSV row)
  - Eliminates ~1.18M relationship checks from Pass 2
- `Create_git_log_repo_author_relationships.cypher`
  - MATCH (repo), query for distinct authors via AUTHORED+CONTAINS_CHANGED+repositoryPath
  - MERGE (repo)-[:HAS_AUTHOR]->(author) once per unique author
  - Eliminates ~590k relationship checks from Pass 2
- `Create_git_log_repo_file_relationships.cypher`
  - MATCH (repo), MATCH all Git:Log:File nodes with matching repositoryPath
  - MERGE (repo)-[:HAS_FILE]->(file) once per unique file (not per CSV row)
  - Eliminates ~1.38M relationship checks from Pass 2
- **Pass 3 total gain: ~3.15M DB accesses moved from Pass 2 to a deduplicated context**

### Phase 3 — Update orchestration (`importGit.sh`) — ✅ IMPLEMENTED

1. `createGitLogData.sh` now accepts **two positional parameters**:
   - Param 1: `gitLog.csv` path
   - Param 2: `gitLogCommits.csv` path
   - Produces both CSVs in one `createGitLogData.sh` invocation (two separate git log runs)

2. `importGitLog()` function in `importGit.sh` now runs:
   - Create indexes (author, commit hash, commit parent, file name)
   - **Pass 1**: `time execute_cypher Import_git_log_nodes_csv_data.cypher`
   - **Assertion**: `execute_cypher_expect_results Verify_git_log_commits_imported.cypher` + `is_csv_column_greater_zero` check; exits 1 if missingCommitCount > 0
   - **Pass 2**: `time execute_cypher Import_git_log_relationships_csv_data.cypher` (with repo param)
   - **Pass 3a**: `execute_cypher Create_git_log_repo_commit_relationships.cypher` (with repo param)
   - **Pass 3b**: `execute_cypher Create_git_log_repo_author_relationships.cypher` (with repo param)
   - **Pass 3c**: `execute_cypher Create_git_log_repo_file_relationships.cypher` (with repo param)
   - Create parent commit relationships (existing, unchanged)

3. Main loop in `importGit.sh` now passes both CSV paths to `createGitLogData.sh`

4. `postGitLogImport()` remains unchanged — runs after all repos processed (outside per-repo loop)

---

## Expected Improvement (Pre-Implementation Estimate)

**From 8.2M DB accesses down to:**
- Pass 1: ~14k DB accesses (13,750 rows, minimal relationship checks)
- Pass 2: ~2.3M DB accesses (92,300 rows, CONTAINS_CHANGED + renames/deletes only; HAS_* removed)
- Pass 3: ~1.5M DB accesses (DISTINCT lookups scoped by repositoryPath, deduplicated per node type)
- **Total: ~3.8M vs. 8.2M** — ~54% reduction, potentially saving 1-2 minutes

---

## Implementation Summary

This plan was fully implemented in a single session with eight discrete tasks:

| Task | Status | Result |
|------|--------|--------|
| Create Pass 1 Cypher (nodes) | ✅ | [Import_git_log_nodes_csv_data.cypher](../../domains/git-history/queries/enrichment/Import_git_log_nodes_csv_data.cypher) |
| Create Pass 2 Cypher (relationships) | ✅ | [Import_git_log_relationships_csv_data.cypher](../../domains/git-history/queries/enrichment/Import_git_log_relationships_csv_data.cypher) |
| Create Pass 3 Cypher (3 queries) | ✅ | [Create_git_log_repo_commit_relationships.cypher](../../domains/git-history/queries/enrichment/Create_git_log_repo_commit_relationships.cypher), [Create_git_log_repo_author_relationships.cypher](../../domains/git-history/queries/enrichment/Create_git_log_repo_author_relationships.cypher), [Create_git_log_repo_file_relationships.cypher](../../domains/git-history/queries/enrichment/Create_git_log_repo_file_relationships.cypher) |
| Create assertion query | ✅ | [Verify_git_log_commits_imported.cypher](../../domains/git-history/queries/validation/Verify_git_log_commits_imported.cypher) |
| Update createGitLogData.sh | ✅ | Two-CSV output, lean gitLog.csv schema, epoch seconds, parameterized paths |
| Update importGit.sh | ✅ | Three-pass + assertion orchestration, dual CSV paths, `is_csv_column_greater_zero` assertion |
| Delete old single-pass query | ✅ | Import_git_log_csv_data.cypher removed |
| Verify with shellcheck | ✅ | Both shell scripts pass (SC1091 notices expected) |



| File | Change | Status |
|------|--------|--------|
| `createGitLogData.sh` | Two positional params (gitLog.csv, gitLogCommits.csv); two git log runs; lean gitLog.csv schema | ✅ |
| `importGit.sh` | importGitLog() now 3-pass + assertion; pass both CSV paths to createGitLogData.sh | ✅ |
| `Import_git_log_csv_data.cypher` | **DELETE** | ✅ |
| `Import_git_log_nodes_csv_data.cypher` | **NEW** — Pass 1 (node/author creation + AUTHORED) | ✅ |
| `Import_git_log_relationships_csv_data.cypher` | **NEW** — Pass 2 (file nodes + CONTAINS_CHANGED + renames/deletes) | ✅ |
| `Create_git_log_repo_commit_relationships.cypher` | **NEW** — Pass 3a (HAS_COMMIT once per unique commit) | ✅ |
| `Create_git_log_repo_author_relationships.cypher` | **NEW** — Pass 3b (HAS_AUTHOR once per unique author) | ✅ |
| `Create_git_log_repo_file_relationships.cypher` | **NEW** — Pass 3c (HAS_FILE once per unique file) | ✅ |
| `Verify_git_log_commits_imported.cypher` | **NEW** — Pass 1→2 assertion (validation/) | ✅ |

## Decisions — ✅ IMPLEMENTED

- **Use epoch seconds, not ISO string** — saves datetime parsing overhead (minor benefit) ✅
- **Reduce batch size to 500** — better memory management during relationship checks ✅
- **Three-pass (mandatory Pass 3)** — drastically reduces simultaneous relationship lookups ✅
  - Plan originally marked Pass 3 "optional" — corrected to **mandatory** since it eliminates ~38% of DB accesses (3.15M of 8.2M)
- **MATCH existing nodes in Pass 2** — leverages caching from Pass 1 ✅
- **Move HAS_FILE, HAS_COMMIT, HAS_AUTHOR to Pass 3** — not created per CSV row in Pass 2 (plan originally suggested incoherent "pre-create in Pass 1"); now deduplicated per unique node ✅
- **Assertion query between Pass 1 and Pass 2** — fails fast on incomplete Pass 1 import ✅
- **Lean gitLog.csv schema** — strip commit metadata (hash,filename,change_type,old_filename); separate gitLogCommits.csv carries commit+author data ✅

## Verification — ⏳ NEXT STEPS

**Implementation complete.** Next steps:
1. Run `PROFILE` on the new Cypher files separately to verify DB accesses are reduced
2. Total DB accesses should drop from 8.2M to <3M
3. End result same: 250 authors, 13,750 commits, 17,484 files
4. Test full import with `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="full" analyze.sh --domain git-history --skip-jqassistant`

**Files verified:**
- Both shell scripts pass `shellcheck` (SC1091 notices are acceptable/expected for sourced paths)
- All new Cypher queries follow conventions in [cypher-queries.instructions.md](../../.github/instructions/cypher-queries.instructions.md)
