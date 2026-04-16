# Plan: Create Git History Domain

## TL;DR

Create `domains/git-history/` as a new vertical-slice domain covering all git history analysis — directory commit statistics, co-changed files, pairwise file metrics, author analysis, and git import orchestration. Copy all 42 GitLog Cypher queries (organized as enrichment/statistics/validation), the import scripts (importGit.sh, createGitLogCsv.sh, createAggregatedGitLogCsv.sh), and GitHistoryCsv.sh reporting logic. Convert GitHistoryGeneral.ipynb charts (~20 treemaps, bar charts, histograms) into a standalone Python script. Copy both notebooks into explore/ with validation disabled. Create a Markdown summary report. No moves or deletions of originals.

## Decisions

- **Domain name**: `git-history`
- **Cypher organization**: Three subdirectories — `enrichment/` (import, indexing, relationship creation, property setting), `statistics/` (listing/querying for reports), `validation/` (verification queries)
- **importGit.sh handling**: Copy into domain `import/` directory. Keep original. Add TODO comment to `scripts/resetAndScan.sh` reference line noting the dependency direction (core → domain) should be revisited.
- **createGitLogCsv.sh + createAggregatedGitLogCsv.sh**: Copy into domain `import/`
- **Report output directory**: `reports/git-history` (matches domain name, breaking change vs. old `reports/git-history-csv/`)
- **GitHistoryGeneral.ipynb**: All ~20 charts converted to Python script
- **GitHistoryExploration.ipynb**: Exploration notebook only (correlation analysis not in report)
- **Wordcloud**: Git author wordcloud included (cypher query `Words_for_git_author_Wordcloud_with_frequency.cypher` copied)
- **Entry point naming**: `gitHistoryCsv.sh`, `gitHistoryPython.sh`, `gitHistoryMarkdown.sh` (no Visualization entry point — no GraphViz graph visualizations in git history)
- **No-git-data handling**: The analyzed codebase may have no git history at all. All entry points must handle this gracefully: `gitHistoryCsv.sh` produces no output files (cleanup removes empty CSVs → no report dir created); `gitHistoryCharts.py` skips chart generation if input CSVs are absent; `gitHistoryMarkdown.sh` detects absence of the report dir and renders `report_no_git_data.template.md` instead.

## Domain Directory Structure

```
domains/git-history/
├── README.md
├── PREREQUISITES.md
├── COPIED_FILES.md
├── gitHistoryCsv.sh                    # Entry point: CSV reports (*Csv.sh)
├── gitHistoryPython.sh                 # Entry point: Python charts (*Python.sh)
├── gitHistoryMarkdown.sh               # Entry point: Markdown summary (*Markdown.sh)
├── gitHistoryCharts.py                 # Chart generation: treemap, bar, histogram → SVG
├── explore/
│   ├── GitHistoryGeneralExploration.ipynb
│   └── GitHistoryCorrelationExploration.ipynb
├── import/
│   ├── importGit.sh                    # Git data import orchestrator
│   ├── createGitLogCsv.sh             # Full git log → CSV
│   └── createAggregatedGitLogCsv.sh   # Aggregated git log → CSV
├── queries/
│   ├── enrichment/                     # 26 files: import, indexing, relationships, property setting
│   ├── statistics/                     # 13 files: listing and querying for reports
│   └── validation/                     # 5 files: verification and validation queries
└── summary/
    ├── gitHistorySummary.sh            # Markdown assembly logic
    ├── report.template.md              # Main report template
    └── report_no_git_data.template.md  # Fallback: no git data
```

## Steps

### Phase 1: Scaffolding & Documentation

1.1 Create directory structure: `domains/git-history/{explore,import,queries/{enrichment,statistics,validation},summary}`

1.2 Create `PREREQUISITES.md` documenting external dependencies:
  - Neo4j running with scanned artifacts
  - Git history imported (importGit.sh or plugin); IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT env var
  - Git:File ← RESOLVES_TO → code files (Java + TypeScript)
  - CHANGED_TOGETHER_WITH relationships between Git:Files and resolved code files
  - numberOfGitCommits property on code File nodes
  - updateCommitCount property on Git:File nodes
  - isMergeCommit, isAutomatedCommit classification properties on commits
  - General enrichment: `name`, `extension` properties on File nodes from cypher/General_Enrichment/
  - executeQueryFunctions.sh, cleanupAfterReportGeneration.sh (central pipeline scripts)

1.3 Create `COPIED_FILES.md` tracking all original → copy mappings for deprecation follow-up

1.4 Create `README.md` — domain overview, entry points, folder structure, prerequisites reference, output description

### Phase 2: Copy Cypher Queries

2.1 Copy enrichment queries (26 files) from `cypher/GitLog/` → `queries/enrichment/`:
  - Import: Import_git_log_csv_data, Import_aggregated_git_log_csv_data
  - Repository: Create_git_repository_node
  - Deletion: Delete_git_log_data, Delete_plain_git_directory_file_nodes
  - Indexes (8): Index_absolute_file_name, Index_author_name, Index_change_span_year, Index_commit_hash, Index_commit_parent, Index_commit_sha, Index_file_name, Index_file_relative_path
  - Relationships (4): Add_CHANGED_TOGETHER_WITH_relationships_to_code_files, Add_CHANGED_TOGETHER_WITH_relationships_to_git_files, Add_HAS_PARENT_relationships_to_commits, Add_RESOLVES_TO_relationships_to_git_files_for_Java, Add_RESOLVES_TO_relationships_to_git_files_for_Typescript
  - Properties (5): Set_commit_classification_properties, Set_number_of_aggregated_git_commits, Set_number_of_git_log_commits, Set_number_of_git_plugin_commits, Set_number_of_git_plugin_update_commits

2.2 Copy statistics queries (13 files) from `cypher/GitLog/` → `queries/statistics/`:
  - List_ambiguous_git_files, List_git_file_directories_with_commit_statistics, List_git_files_by_resolved_label_and_extension, List_git_files_per_commit_distribution, List_git_files_that_were_changed_together, List_git_files_that_were_changed_together_all_in_one, List_git_files_that_were_changed_together_with_another_file, List_git_files_that_were_changed_together_with_another_file_all_in_one, List_git_files_with_commit_statistics_by_author, List_pairwise_changed_files, List_pairwise_changed_files_top_selected_metric, List_pairwise_changed_files_with_dependencies, List_unresolved_git_files
  - Also copy: `cypher/Overview/Words_for_git_author_Wordcloud_with_frequency.cypher`

2.3 Copy validation queries (5 files) from `cypher/GitLog/` → `queries/validation/`:
  - Verify_code_to_git_file_unambiguous, Verify_git_missing_CHANGED_TOGETHER_WITH_properties, Verify_git_missing_create_date, Verify_git_to_code_file_unambiguous
  - Also copy: `cypher/Validation/ValidateGitHistory.cypher`

### Phase 3: Copy Import Scripts

3.1 Copy `scripts/importGit.sh` → `import/importGit.sh`
  - Update CYPHER_DIR references to point to `../queries/enrichment/` instead of `${CYPHER_DIR}/GitLog`
  - Update sourced scripts references: createGitLogCsv.sh, createAggregatedGitLogCsv.sh to use domain-local paths

3.2 Copy `scripts/createGitLogCsv.sh` → `import/createGitLogCsv.sh` (no changes needed)

3.3 Copy `scripts/createAggregatedGitLogCsv.sh` → `import/createAggregatedGitLogCsv.sh` (no changes needed)

3.4 Add TODO comment to `scripts/resetAndScan.sh` at the `source "${SCRIPTS_DIR}/importGit.sh"` line noting the core → domain dependency direction should be revisited (*depends on 3.1*)

### Phase 4: Create CSV Entry Point Script (*depends on 2.2*)

4.1 Create `gitHistoryCsv.sh`:
  - Follow boilerplate from `internalDependenciesCsv.sh`: BASH_SOURCE/CDPATH directory resolution, `set -o errexit -o pipefail`
  - Source `../../scripts/executeQueryFunctions.sh`
  - Report name: `git-history`, output to `reports/git-history/`
  - Execute statistics queries (adapted from `scripts/reports/GitHistoryCsv.sh`):
    - List_git_files_with_commit_statistics_by_author → CSV
    - List_git_files_that_were_changed_together_with_another_file → CSV
    - List_git_file_directories_with_commit_statistics → CSV
    - List_git_files_per_commit_distribution → CSV
    - List_pairwise_changed_files_with_dependencies → CSV
    - List_pairwise_changed_files_top_selected_metric × 4 metrics (count, min_confidence, jaccard, lift) → CSVs
    - Also: List_git_files_by_resolved_label_and_extension, List_ambiguous_git_files, List_unresolved_git_files (for data quality)
    - Also: Words_for_git_author_Wordcloud_with_frequency → CSV (for the wordcloud)
  - Clean up empty reports via `cleanupAfterReportGeneration.sh`
  - **No-data case**: if all queries return empty results, `cleanupAfterReportGeneration.sh` removes all CSVs and the report dir will not exist — this is the signal used downstream

### Phase 5: Create Python Charts Script (*parallel with Phase 4*)

5.1 Create `gitHistoryCharts.py`:
  - Follow `Parameters` class pattern from `pathFindingCharts.py` and `treemapVisualizations.py`
  - CLI: `--report_directory`, `--verbose` arguments
  - Neo4j connection via `bolt://localhost:7687` with `NEO4J_INITIAL_PASSWORD`
  - Load CSV data from report directory (not querying Neo4j for charts — uses CSV output from Phase 4)
  - **No-data case**: if the report directory does not exist or the required CSV files are absent, log a warning and exit 0 without generating any SVGs

5.2 Data preparation functions (extracted from GitHistoryGeneral.ipynb):
  - `add_quantile_limited_column(data_frame, column_name, quantile)` → DataFrame
  - `add_rank_column(data_frame, column_name)` → DataFrame
  - `add_file_extension_column(data_frame, file_path_column)` → DataFrame
  - `add_directory_column(data_frame, file_path_column)` → DataFrame (explodes paths into directories)
  - `add_directory_name_column(data_frame, directory_column)` → DataFrame
  - `add_parent_directory_column(data_frame, directory_column)` → DataFrame
  - Aggregation helpers: `get_last_entry`, `collect_as_array`, `second_entry`, `get_flattened_unique_values`, `count_unique_aggregated_values`, `get_most_frequent_entry`

5.3 Directory commit statistics preparation (the multi-step grouping pipeline from notebook cells 22):
  - Query Neo4j for `List_git_files_with_commit_statistics_by_author.cypher`
  - Extract author rankings, file extension rankings
  - Group by directory+author → group by directory only → add names/parents → final grouping
  - Produces the hierarchical directory structure for treemaps

5.4 Treemap chart functions (~13 charts):
  - Number of files per directory
  - Most frequent file extension per directory
  - Number of commits per directory
  - Number of distinct authors per directory
  - Directories with very few different authors (low focus)
  - Main author per directory
  - Second author per directory
  - Days since last commit per directory
  - Days since last commit per directory (ranked)
  - Days since last file creation per directory
  - Days since last file creation per directory (ranked)
  - Days since last file modification per directory
  - Days since last file modification per directory (ranked)

5.5 Co-change treemap charts (~3 charts):
  - Files that likely co-change with others
  - Co-changing files max lift
  - Co-changing files average lift

5.6 Bar chart: files per commit distribution (1 chart)

5.7 Histogram charts (~4 charts, one per metric):
  - Co-changed files by commit count
  - Co-changed files by commit min confidence
  - Co-changed files by commit lift
  - Co-changed files by commit Jaccard similarity

5.8 Git author wordcloud (1 chart — using wordcloud library)

5.9 All charts saved as SVG to `reports/git-history/`

### Phase 6: Create Python Entry Point (*depends on 5.1*)

6.1 Create `gitHistoryPython.sh`:
  - Follow pattern of `internalDependenciesPython.sh`
  - Execute `gitHistoryCharts.py` with `--report_directory` and optional `--verbose`
  - Clean up empty reports

### Phase 7: Create Exploration Notebooks (*parallel with Phase 5*)

7.1 Copy `jupyter/GitHistoryGeneral.ipynb` → `explore/GitHistoryGeneralExploration.ipynb`:
  - Change title from "# git log/history" to "# Git History General Exploration"
  - Set metadata: `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
  - Update cypher file path references from `../cypher/GitLog/` to `../queries/statistics/`

7.2 Copy `jupyter/GitHistoryExploration.ipynb` → `explore/GitHistoryCorrelationExploration.ipynb`:
  - Change title from "# git log/history" to "# Git History Correlation Exploration"
  - Set metadata: `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
  - Update cypher file path references from `../cypher/GitLog/` to `../queries/statistics/`

### Phase 8: Create Markdown Summary (*depends on Phases 4, 5*)

8.1 Create `summary/report.template.md`:
  - Front matter (title, date, version, dataset)
  - Section 1: Overview — what to act on first, reading guide
  - Section 2: Directory Commit Statistics — treemap charts, tables
  - Section 3: Co-Changed Files — treemap charts, top pairwise tables
  - Section 4: File Change Distribution — bar chart, statistics
  - Section 5: Pairwise Changed Files — tables per metric (count, confidence, Jaccard, lift)
  - Section 6: Data Quality — ambiguous files, unresolved files, file resolution statistics
  - Section 7: Git Author Wordcloud
  - Section 8: Glossary

8.2 Create `summary/report_no_git_data.template.md`:
  - Fallback: "⚠️ No git history data available"

8.3 Create `summary/gitHistorySummary.sh`:
  - Follow pattern of `internalDependenciesSummary.sh`
  - **No-data detection**: check if the report directory (`reports/git-history/`) exists and contains data; if not, render `report_no_git_data.template.md` as the final report and exit early
  - Generate front matter
  - Execute queries for Markdown table includes (limited to 10 rows)
  - Include SVG chart references
  - Assemble final report via embedMarkdownIncludes.sh

8.4 Create `gitHistoryMarkdown.sh`:
  - Follow pattern of `internalDependenciesMarkdown.sh`
  - Delegates to `summary/gitHistorySummary.sh`

## Relevant Files

**Reference implementations (read, not modified):**
- `domains/internal-dependencies/` — primary reference for domain structure, all entry point patterns, summary assembly
- `domains/anomaly-detection/treemapVisualizations.py` — reference for Python chart script with Neo4j connection
- `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb` — reference for ValidateAlwaysFalse metadata
- `domains/internal-dependencies/pathFindingCharts.py` — reference for chart generation patterns
- `.github/prompts/plan-internal_dependencies_domain.prompt.md` — reference plan structure

**Source files to copy (not modified):**
- `cypher/GitLog/` — all 42 files
- `cypher/Overview/Words_for_git_author_Wordcloud_with_frequency.cypher`
- `cypher/Validation/ValidateGitHistory.cypher`
- `scripts/reports/GitHistoryCsv.sh` — logic adapted into gitHistoryCsv.sh
- `scripts/importGit.sh` — copied with path adjustments
- `scripts/createGitLogCsv.sh` — copied unchanged
- `scripts/createAggregatedGitLogCsv.sh` — copied unchanged
- `jupyter/GitHistoryGeneral.ipynb` — copied with metadata + title changes
- `jupyter/GitHistoryExploration.ipynb` — copied with metadata + title changes

**Modified (minimally):**
- `scripts/resetAndScan.sh` — add TODO comment at importGit.sh reference

**Central scripts sourced (not copied):**
- `scripts/executeQueryFunctions.sh` — provides execute_cypher(), execute_cypher_queries_until_results()
- `scripts/cleanupAfterReportGeneration.sh` — removes empty CSV files
- `scripts/markdown/embedMarkdownIncludes.sh` — assembles Markdown includes into final report

## Verification

1. Run `shellcheck domains/git-history/*.sh domains/git-history/**/*.sh` — no errors
2. Run `python -m py_compile domains/git-history/gitHistoryCharts.py` — no syntax errors
3. Verify all cypher files copied match originals: `diff cypher/GitLog/<file> domains/git-history/queries/enrichment/<file>`
4. Verify notebook metadata: `grep "ValidateAlwaysFalse" domains/git-history/explore/*.ipynb` returns matches
5. Verify entry point discovery: `find domains/git-history -name "*Csv.sh" -o -name "*Python.sh" -o -name "*Markdown.sh"` returns 3 files
6. Manual: Open exploration notebooks in VS Code, confirm they display correctly
7. Integration test (if Neo4j available): Run `gitHistoryCsv.sh` and verify CSV files in `reports/git-history/`

## Scope Boundaries

**Included:**
- All 42 GitLog cypher queries + 2 external (wordcloud, validation)
- Import scripts (importGit.sh, createGitLogCsv.sh, createAggregatedGitLogCsv.sh)
- CSV reporting logic from GitHistoryCsv.sh
- All ~20 charts from GitHistoryGeneral.ipynb as Python SVGs
- Git author wordcloud
- Both exploration notebooks
- Markdown summary report with tables, charts, glossary
- TODO comment on resetAndScan.sh

**Excluded:**
- No Visualization entry point (no GraphViz graphs in git history)
- No move/deletion of originals
- Correlation analysis stays exploration-only (no Python script for scatter plots)
- No changes to central pipeline discovery mechanism
- General_Enrichment cypher not copied (documented as prerequisite)
