# Plan: Fix CSV Full-Mode Git Import to Close Parity Gap with jQAssistant Plugin

The "full" CSV mode should work correctly for SCIP-based (no jQAssistant) analysis. Here's what needs to happen across 8 phases, structured by dependency order.

---

**Phases 1–2 are the foundation; everything else depends on them. Phases 5 and 6 can proceed in parallel with Phases 7–8.**

### Phase 1 — CSV generation rewrite (createGitLogCsv.sh)

1. Remove `--no-merges` — include merge commits in the CSV.
2. Switch `--name-only` → `--name-status` for rename tracking.
3. Extend CSV schema: `hash,parent,author,email,timestamp,timestamp_unix,message,filename,change_type,old_filename`
   - Regular rows: `change_type` = A/M/D/C, `old_filename` = empty
   - Rename rows: `change_type` = R, `filename` = new path, `old_filename` = old path
4. Rewrite the awk parser to handle the `STATUS\tfile` and `RSTATUS\told\tnew` formats.
5. Remove `grep -v -F '[bot]'` — Cypher classification handles this correctly once `author` is on commit nodes (Phase 2).
6. Add `IFS=$'\n\t'`.

### Phase 2 — CSV import schema upgrade (Import_git_log_csv_data.cypher)

1. Change MERGE key to `{hash: row.hash}` only; move all other properties to `ON CREATE SET` — this makes the hash index usable.
2. Set `author: row.author` and `date: date(row.timestamp)` on the commit node — unblocks bot classification and statistics queries.
3. Keep `sa: row.hash` via `SET` (not MERGE key) for statistics compatibility.
4. For R-type rows: create old file node + `(old)-[:HAS_NEW_NAME]->(new)` relationship.
5. For D-type rows: set `git_file.deletedAt = git_commit.timestamp`.
6. Fix comment: `HAS_HAS_COMMIT` → `HAS_COMMIT`.

### Phase 3 — New and updated enrichment queries (*depends on Phase 1+2*)

1. **New** Set_git_log_file_dates.cypher: compute `createdAtEpoch` (min commit timestamp for A-type rows) and `lastModificationAtEpoch` (max commit timestamp) on `Git:Log:File` nodes. These properties are referenced by the statistics queries.
2. **Update** Add_HAS_PARENT_relationships_to_commits.cypher: `UNWIND split(git_commit.parent, ' ') AS parentHash` — handles the space-separated multi-parent hashes that merge commits produce (`%P` format).
3. Call the new enrichment query from `postGitLogImport()` in importGit.sh.

> `Set_commit_classification_properties.cypher` needs **no changes** — it matches `(:Git:Commit)` (which catches `Git:Log:Commit` via label subset matching), and after Phase 2 sets `author` on commit nodes, `isBotAuthor` and `isMergeCommit` both work correctly.

### Phase 4 — Fix CHANGED_TOGETHER_WITH for merge commits (*depends on Phase 3*)

Both variants need two changes:

1. Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher (plugin) and Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher (CSV): add `AND NOT git_commit.isMergeCommit` to the `WHERE git_commit.isManualCommit` clause.
2. Remove `collect(DISTINCT commitHash) AS updateCommitHashes` and the corresponding `SET pairwiseChange.updateCommitHashes` — no query reads it, it's pure storage overhead.

### Phase 5 — CSV statistics query variants (*parallel with Phase 7–8, depends on Phases 1–3*)

Four new files under queries/statistics/, each using the `Git:Log:*` schema:

| New file | Pattern used instead of plugin's |
|---|---|
| List_git_files_per_commit_distribution_csv.cypher | `[:CONTAINS_CHANGED]->(Git:Log:File)`, count by `fileName` |
| Words_for_git_author_Wordcloud_with_frequency_csv.cypher | `(Git:Log:Author)-[:AUTHORED]` |
| List_git_files_with_commit_statistics_by_author_csv.cypher | `[:CONTAINS_CHANGED]->(file_in_commit)-[:HAS_NEW_NAME*0..3]->(git_file)`, `git_commit.author`, `git_commit.date`, `coalesce(relativePath, fileName)` |
| List_git_file_directories_with_commit_statistics_csv.cypher | Same pattern substitution as above; directory grouping logic identical |

**One fix to an existing query** (not a new file): List_git_files_that_were_changed_together_with_another_file.cypher — change `gitRepository.name + '/' + firstGitFile.relativePath` to `gitRepository.name + '/' + coalesce(firstGitFile.relativePath, firstGitFile.fileName)`.

### Phase 6 — Mode detection in gitHistoryCsv.sh (*depends on Phase 5*)

Read `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` and select the query variant for each of the 4 replaced outputs. When the value is `full`, call the `*_csv.cypher` file; otherwise call the plugin query unchanged. Default (plugin) behaviour is preserved.

### Phase 7 — Multi-repo loop restructure (importGit.sh) (*parallel with Phases 5–6*)

1. Move `postGitLogImport` **outside** the per-repo loop.
2. Keep `create_git_repository_node`, CSV generation, and `importGitLog` **inside** the loop.
3. Guard: only call `postGitLogImport` if at least one repo was imported (the existing `existing_data_has_been_deleted` flag already tracks this).

This changes the work from O(n×N) to O(N) for n repositories, and eliminates cross-repo co-change artifacts.

### Phase 8 — Minor fixes (*independent*)

- postGitPluginImport in importGit.sh: the duplicate call to `Set_number_of_git_plugin_update_commits.cypher` (lines 206 and 213) needs comments explaining why it runs twice (first: sets `updateCommitCount` on git files before `CHANGED_TOGETHER_WITH` needs it; second: propagates to code files after `RESOLVES_TO` is created). The current code is correct but silently confusing.

### Phase 9 — Unit tests for CSV generation and import (testCreateGitLogCsv.sh) (*depends on Phase 1, parallel with Phase 8*)

Create `domains/git-history/testCreateGitLogCsv.sh` — isolated unit tests for CSV generation logic. Uses only the repository's own git history (no external clone).

**Test harness structure** (following `domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh` pattern):

1. **Setup**: Create temporary directories for test fixtures. Use `mktemp -d` and trap `EXIT` for cleanup.
2. **Assertion helpers**: `assert_exit_code()`, `assert_contains()`, `assert_not_contains()`, `assert_file_exists()`, `assert_line_count()`, `assert_csv_row_count()`.
3. **Test fixtures**: Create minimal git repositories with controlled commits (merge, rename, bot commits, etc.) using `git init` and `git commit` in temp dirs.

**Test cases**:

- **CSV header**: Validate exact header line: `hash,parent,author,email,timestamp,timestamp_unix,message,filename,change_type,old_filename`
- **Regular commits** (add/modify files): Verify A/M rows with `change_type` set correctly, `old_filename` empty.
- **File deletion**: Verify D rows are present, `old_filename` empty.
- **File rename**: Create a repo with a rename (`git mv`), verify R-type row with both `filename` (new path) and `old_filename` (old path).
- **Merge commits**: Create a merge, verify both parents appear in `parent` field (space-separated), verify commit is included (not filtered by `--no-merges`).
- **Bot author filtering removed**: Verify commits with `[bot]` in author name are still included in CSV (filtering now happens in Cypher). Counts as a pass if author line is present verbatim.
- **Multiple files per commit**: Commit multiple files in one shot, verify multiple CSV rows (one per file).
- **Escape handling**: Verify CSV escaping for:
  - Commas in commit message → quoted field
  - Double quotes in commit message → escaped as `""`
  - Backslashes in commit message → replaced with space (per existing logic)
  - Newlines in commit message → handled correctly (git log %s doesn't include newlines; %b would)
- **Empty repository**: Run script on repo with no commits, verify exit code 0 and CSV contains only header.
- **Author email extraction**: Verify email field correctly extracted from `git log` output when present/absent.

**Execution**:

- Run from the test script's directory (`testCreateGitLogCsv.sh`), not from the project root — tests create isolated temp fixtures.
- Do not require Neo4j running.
- Do not clone external repositories.
- Use `set -o errexit -o pipefail -o nounset` and `IFS=$'\n\t'`.
- Track `PASS_COUNT` and `FAIL_COUNT`; exit 1 if any failures.
- Call via `runTests.sh` (auto-discovery by prefix `test*`).

---

## Relevant files modified or created

- domains/git-history/import/createGitLogCsv.sh — complete rewrite
- domains/git-history/queries/enrichment/Import_git_log_csv_data.cypher — schema upgrade
- domains/git-history/queries/enrichment/Add_HAS_PARENT_relationships_to_commits.cypher — multi-parent split
- domains/git-history/queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher — merge filter + remove hash collection
- domains/git-history/queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher — same
- domains/git-history/queries/enrichment/Set_git_log_file_dates.cypher — **new**
- 4 new `*_csv.cypher` files in domains/git-history/queries/statistics/
- domains/git-history/queries/statistics/List_git_files_that_were_changed_together_with_another_file.cypher — null path fix
- domains/git-history/gitHistoryCsv.sh — mode detection
- domains/git-history/import/importGit.sh — loop restructure + Phase 8 doc
- domains/git-history/testCreateGitLogCsv.sh — **new, Phase 9**

---

## Verification

1. `shellcheck domains/git-history/import/createGitLogCsv.sh` and `importGit.sh`
2. Run `domains/git-history/testCreateGitLogCsv.sh` — all tests pass with no Neo4j running.
3. Run `analyze.sh --domain git-history --report Csv --keep-running` with a SCIP-based workspace (`IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=full`). Confirm all 9 CSVs in `reports/git-history/` are non-empty.
4. Confirm renamed files appear with stitched commit history (not split at the rename point).
5. Confirm merge commits are excluded from `CHANGED_TOGETHER_WITH` (spot-check `isMergeCommit` on a known merge commit node).
6. Run the same analysis in plugin mode (`IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=plugin`) — confirm no regression.
---

## Out of scope

- `aggregated` mode improvements
- Branch scoping for `git log`
