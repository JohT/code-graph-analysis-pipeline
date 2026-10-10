# Plan: Full Git Log Import Multi-Pass Optimization (REVISED with PROFILE data)

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

### Phase 2 — Three Cypher Files (replaces the current single import)

**Pass 1: Create all nodes** (reads `gitLogCommits.csv`)
- `Import_git_log_nodes_csv_data.cypher`
  - MERGE `Git:Log:Author {name, email}` — **0 relationship checks**
  - MERGE `Git:Log:Commit {hash}` ON CREATE SET timestamp properties using `datetime({epochSeconds: toInteger(row.timestamp_unix)})` — **0 relationship checks**
  - MERGE `(author)-[:AUTHORED]->(commit)` — **1 relationship check per unique commit**
  - Result: Only 13,750 rows, ~13,750 relationship checks (vs. 92,300 × 1 = 92,300 in single pass)
  - `IN TRANSACTIONS OF 500 ROWS`

**Pass 2: Create file nodes and change relationships** (reads `gitLog.csv`)
- `Import_git_log_relationships_csv_data.cypher`
  - **MATCH** `Git:Log:Commit {hash}` — not MERGE, nodes cached from Pass 1
  - MERGE `Git:Log:File {fileName, repositoryPath}` — **~17,484 relationship checks**
  - MERGE `(commit)-[:CONTAINS_CHANGED]->(file)` — **~92,300 relationship checks** (one per CSV row, but commit already exists)
  - MERGE `(repo)-[:HAS_FILE]->` — **~92,300 relationship checks** BUT these can be optimized: see below
  - FOREACH rename: MERGE old_file, create HAS_NEW_NAME relationship
  - FOREACH delete: SET git_file.deletedAt
  - `IN TRANSACTIONS OF 500 ROWS`

**Optimization for Pass 2:** Since `(repo)-[:HAS_FILE]->` is created for every git file, consider:
- Pre-create a single `(repo)-[:HAS_FILE]->` relationship once in Pass 1 (or via a separate query)
- Then in Pass 2, skip the MERGE and just MATCH it — **eliminates 92,300 relationship checks**

**Pass 3 (optional, separate): Repository-level relationships** — run ONCE after all files imported
- `Import_git_log_repo_relationships_csv_data.cypher`
  - MATCH (repo), MATCH (author), MERGE (repo)-[:HAS_AUTHOR]->(author) — run once for each unique author
  - MATCH (repo), MATCH (commit), MERGE (repo)-[:HAS_COMMIT]->(commit) — run once for each unique commit
  - Or collapse into Pass 1 if performance is acceptable

### Phase 3 — Update orchestration (`importGit.sh`)

1. Pass both CSV paths to `createGitLogData.sh`
2. In `importGitLog()`:
   - Call `Import_git_log_nodes_csv_data.cypher` (with `time`)
   - Call `Import_git_log_relationships_csv_data.cypher` (with `time`)
   - Call `Add_HAS_PARENT_relationships_to_commits.cypher` (existing, unchanged)
   - Delete call to `Import_git_log_csv_data.cypher`

---

## Expected Improvement

**From 8.2M DB accesses down to:**
- Pass 1: ~50k DB accesses (13,750 rows, minimal relationship checks)
- Pass 2: ~2-3M DB accesses (17,484 rows, fewer parallel relationship checks per batch)
- **Total: ~2-3M vs. 8.2M** — ~65% reduction, potentially saving 2-3 minutes

This is speculative without actually running it, but the PROFILE proves the relationship checks are the bottleneck.

---

## Files Modified
- `createGitLogData.sh` — add second git log run and second CSV output param
- `importGit.sh` — pass both CSV paths, call two/three Cypher files (not one)
- `Import_git_log_csv_data.cypher` — **DELETE**
- `Import_git_log_nodes_csv_data.cypher` — **NEW** (node creation only)
- `Import_git_log_relationships_csv_data.cypher` — **NEW** (relationships only)
- `Import_git_log_repo_relationships_csv_data.cypher` — **NEW (optional)** (repo→node rels once per unique node)

## Decisions
- **Use epoch seconds, not ISO string** — saves datetime parsing overhead (minor benefit)
- **Reduce batch size to 500** — better memory management during relationship checks
- **Two-pass + optional third pass** — drastically reduces simultaneous relationship lookups
- **MATCH existing nodes in Pass 2** — leverages caching from Pass 1

## Verification
1. Run `PROFILE` on each new Cypher file separately to verify DB accesses are reduced
2. Total DB accesses should drop from 8.2M to <3M
3. End result same: 250 authors, 13,750 commits, 17,484 files
