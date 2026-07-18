# Plan: `--skip-jqassistant` Flag

## TL;DR

Add `--skip-jqassistant` to `analyze.sh` that skips jQAssistant download, setup, and scan. Designed for SCIP index analysis (already jQA-free) combined with CSV git history. Also fix the broken `CHANGED_TOGETHER_WITH` enrichment for CSV `full` mode (uses wrong relationship schema) — without it, git history CSV mode has no coupling stats. Add a new internal CI workflow to smoke-test SCIP + git history CSV together.

---

## User-Defined Scope

- **In scope**: pure SCIP, SCIP + git CSV `full` (non-aggregated), SCIP + git CSV `aggregated`
- **Out of scope**: pure git-CSV without SCIP; any Java/TypeScript analysis changes; SCIP domain changes beyond making it work without jQA

---

## Phase 1: Core Pipeline — `analyze.sh`

1. Add `--skip-jqassistant` flag to `analyze.sh`
   - New local variable `skipJQAssistant=false`
   - New case in the argument parser: `--skip-jqassistant` sets `skipJQAssistant=true`
   - Skip `source "${SCRIPTS_DIR}/setupJQAssistant.sh"` when true
   - Skip `source "${SCRIPTS_DIR}/resetAndScanChanged.sh"` when true
   - Export `SKIP_JQASSISTANT=true` for downstream scripts
   - Update `usage()` text
   - Update the `# Requires` comment at the top
   - The "nothing to analyze" check already passes with SCIP indices OR source dir — no change needed

2. Add `--skip-jqassistant` CLI tests to `scripts/testAnalyzeCliOptions.sh`
   - Test: `--skip-jqassistant` is accepted without error
   - Test: `--skip-jqassistant` combined with `--domain git-history` is accepted
   - Test: `--skip-jqassistant` sets SKIP_JQASSISTANT=true (if the test framework allows env var inspection)

**No change to `prepareAnalysis.sh`**: SCIP import always runs before it (analyze.sh order: SCIP import → prepareAnalysis.sh), and SCIP creates `DEPENDS_ON` relationships, satisfying the data verification check. The rest of prepareAnalysis.sh enrichment (Java, TypeScript) is silently no-op for SCIP/git-only graphs.

---

## Phase 2: Fix CHANGED_TOGETHER_WITH for CSV `full` Mode

**Root cause**: `commonPostGitImport()` in `importGit.sh` calls `Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher` which uses the plugin schema:
`(Git:Commit)-[:CONTAINS_CHANGE]->(Git:Change)-[:UPDATES]->(Git:File)`

CSV `full` mode creates: `(Git:Log:Commit)-[:CONTAINS_CHANGED]->(Git:Log:File)` — different relationship name, no intermediate `:Change` node, different property names (`fileName` not `relativePath`, no `deletedAt`).

**Key insight**: `Set_commit_classification_properties.cypher` uses `(git_commit:Git:Commit)`. Since `Git:Log:Commit` nodes have `Git`, `Log`, AND `Commit` labels, this query DOES already work for CSV-mode commits — `isManualCommit` is set correctly.

3. **New Cypher query**: `domains/git-history/queries/enrichment/Set_number_of_git_log_file_update_commits.cypher`

   - Mirrors `Set_number_of_git_plugin_update_commits.cypher` adapted for CSV schema
   - Uses `(git_file:Git:Log:File)<-[:CONTAINS_CHANGED]-(git_commit:Git:Log:Commit)` (note: `Git:Log:File` has `Git`+`Log`+`File` labels, `Git:Log:Commit` has `Git`+`Log`+`Commit` labels)
   - Sets `git_file.updateCommitCount` using distinct commit count by `hash`
   - Also sets `code_file.updateCommitCount` via `RESOLVES_TO` (consistent with plugin version)
   - Reference: `Set_number_of_git_plugin_update_commits.cypher` as template — adapt `[:UPDATES]->(:Git:Change)<-[:CONTAINS_CHANGE]->` to `[:CONTAINS_CHANGED]->` and use `git_commit.hash` instead of `git_commit.sha`

4. **New Cypher query**: `domains/git-history/queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher`

   - Same algorithm as plugin version (`Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher`)
   - Key schema changes:
     - `Git:Log:Commit` + `[:CONTAINS_CHANGED]->` + `Git:Log:File` (no intermediate Change node)
     - `git_commit.hash` instead of `git_commit.sha` (same value but CSV uses `hash` as the property)
     - `git_file.fileName` instead of `git_file.relativePath` for ORDER BY
     - Remove `git_file.deletedAt IS NULL` filter (CSV files don't have `deletedAt`, null-check always true — omit for clarity)
   - Note: `git_file.updateCommitCount` will be available after step 3 above
   - Reference: the full plugin query for structure — preserve all statistical metrics (confidence, lift, Jaccard)

5. **Update `importGit.sh`**: Add calls in `postGitLogImport()` (parallel with step 3-4, depends on step 3 query existing)

   - After `execute_cypher "Set_commit_classification_properties.cypher"`:
     - `execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_log_file_update_commits.cypher"`
     - `execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher"`
   - `commonPostGitImport()` stays unchanged — the plugin CHANGED_TOGETHER_WITH query in it silently no-ops for CSV data
   - `postAggregatedGitLogImport()` needs no change — aggregated data has no commit-level granularity for CHANGED_TOGETHER_WITH

---

## Phase 3: New CI Workflow

6. **New workflow**: `.github/workflows/internal-scip-git-history-no-jqassistant.yml`

   **Structure** (two jobs, consistent with `internal-scip-index-code-example.yml`):

   Job `prepare-scip-and-git-source`:
   - Clone react-router at pinned version using `git clone --depth 50` (shallow, enough history for meaningful coupling stats)
   - Place clone in `temp/<analysis-name>/source/react-router-<version>/`
   - Install pnpm dependencies (same as existing SCIP workflow)
   - Generate SCIP index with `createScipIndexTypescript.sh`
   - Upload SCIP indices artifact (same as existing workflow)
   - Upload sources artifact with `include-hidden-files: true` (for git history)

   Job `analyze-code-graph`:
   - Uses `public-analyze-code-graph.yml`
   - `indices-upload-name`: from prepare job
   - `sources-upload-name`: from prepare job (with git history)
   - `analysis-arguments: "--skip-jqassistant --report Csv"` (Csv is fastest, no Python needed)
   - `run-all-domains: true` (broadest coverage, consistent with existing SCIP workflow)
   - `domain: ""` (all domains, skip-jqassistant mode produces empty results for non-SCIP/non-git domains — harmless)

   Note: `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` defaults to "full" (set in `prepareAnalysis.sh`) when not overridden — git CSV import runs automatically when source with `.git` is present.

   Follow existing `.github/workflows/internal-scip-index-code-example.yml` as the implementation template for triggers, caching, pnpm setup, SCIP CLI install, artifact upload patterns.

---

## Phase 4: Documentation Updates

7. **Update [COMMANDS.md](./COMMANDS.md)**
   - Add `--skip-jqassistant` to the `analyze.sh` options table
   - One-line: "Skip jQAssistant setup/scan; for SCIP index or git-only analysis"

8. **Update [GETTING_STARTED.md](./GETTING_STARTED.md)**
   - Add section "SCIP Index Analysis Without jQAssistant" after prerequisites
   - Explain: place SCIP indices in `indices/` → run `analyze.sh --skip-jqassistant`
   - Link to [domains/scip-index-import/README.md](./domains/scip-index-import/README.md)

9. **Update [domains/git-history/README.md](./domains/git-history/README.md)**
   - Document CSV `full` mode enrichment: update commit counts, CHANGED_TOGETHER_WITH coupling metrics
   - Note: `postGitLogImport()` handles both plugin (jQA) and CSV (log) schemas

10. **Regenerate [SCRIPTS.md](./SCRIPTS.md)**
    - Auto-generated from scripts/ → documents new Cypher queries added in Phase 2
    - Run: `bash scripts/documentation/generateScriptReferences.sh` (or equivalent gen script)

11. **Update [INTEGRATION.md](./INTEGRATION.md)** (optional if CI workflow doc relevant to users)
    - Link new workflow `internal-scip-git-history-no-jqassistant.yml` in "Internal Workflows" section
    - One-line: "Tests SCIP + git history without jQAssistant"

---

## Relevant Files

- `scripts/analysis/analyze.sh` — add `--skip-jqassistant` option; reference `--explore` and `--keep-running` handling as patterns
- `scripts/testAnalyzeCliOptions.sh` — add test cases for `--skip-jqassistant`
- `domains/git-history/import/importGit.sh` — update `postGitLogImport()` function (~line 171)
- `domains/git-history/queries/enrichment/Set_number_of_git_plugin_update_commits.cypher` — template for step 3
- `domains/git-history/queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher` — template for step 4
- `domains/git-history/queries/enrichment/Set_number_of_git_log_file_update_commits.cypher` — NEW
- `domains/git-history/queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher` — NEW
- `.github/workflows/internal-scip-index-code-example.yml` — template for step 6
- `.github/workflows/internal-scip-git-history-no-jqassistant.yml` — NEW
- [COMMANDS.md](./COMMANDS.md) — add `--skip-jqassistant` entry
- [GETTING_STARTED.md](./GETTING_STARTED.md) — SCIP quick-start section
- [domains/git-history/README.md](./domains/git-history/README.md) — CSV mode enrichment details
- [SCRIPTS.md](./SCRIPTS.md) — auto-regenerated (lists new Cypher queries)
- [INTEGRATION.md](./INTEGRATION.md) — optional, link new workflow

---

## Verification

1. `shellcheck scripts/analysis/analyze.sh`
2. `shellcheck domains/git-history/import/importGit.sh`
3. `bash scripts/testAnalyzeCliOptions.sh` — must pass including new `--skip-jqassistant` tests
4. Markdown link check on any modified docs
5. Manual end-to-end: `analyze.sh --skip-jqassistant --domain git-history --report Csv --keep-running` from an analysis workspace containing SCIP indices + source with git
6. Validate CI workflow YAML syntax (GitHub Actions workflow linter or `act` locally)
7. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json COMMANDS.md GETTING_STARTED.md domains/git-history/README.md INTEGRATION.md`

---

## Decisions

- **No change to `prepareAnalysis.sh`**: SCIP always present in scope (SCIP provides DEPENDS_ON); enrichment steps are no-ops for non-Java/TypeScript nodes
- **No change to `public-analyze-code-graph.yml`**: `--skip-jqassistant` passed via existing `analysis-arguments` input
- **No change to SCIP domain**: already jQA-free
- **`IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT`**: relies on existing "full" default from `prepareAnalysis.sh` — no new param needed
- **Shallow clone `--depth 50`**: sufficient for CHANGED_TOGETHER_WITH stats (files changed >2 times), avoids full history download cost in CI
- `commonPostGitImport()` unchanged: plugin CHANGED_TOGETHER_WITH query silently no-ops on CSV data (harmless)

---

## Honest Caveats

1. **CHANGED_TOGETHER_WITH query is moderately complex** (~50-70 lines of Cypher). Must preserve all statistical metrics (confidence, lift, Jaccard, support) — copy structure from plugin version carefully.
2. **Shallow clone depth trade-off**: `--depth 50` may produce sparse coupling stats. `--depth 200` is safer. Worth noting in CI comments.
3. **`IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` default inconsistency**: `prepareAnalysis.sh` defaults to "full", `importGit.sh` defaults to "plugin". The pipeline effective default is "full" (prepareAnalysis.sh runs first). This pre-existing inconsistency is out of scope but worth noting.
4. **Aggregated mode**: `CHANGED_TOGETHER_WITH` cannot be computed from aggregated data (no commit-level granularity) — expected behavior, no fix possible/needed.
