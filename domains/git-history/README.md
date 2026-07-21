# Git History Domain

This directory contains the implementation and resources for analysing **git history** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, shell scripts, and report templates needed for this analysis live here.

This domain covers all git history analysis areas:

- **Directory commit statistics**: How often files in each directory are committed, by whom, and when — as hierarchical treemap charts.
- **Co-changed files**: Files that tend to be modified together in the same commit — indicating hidden coupling.
- **Pairwise file metrics**: Quantified co-change metrics per file pair: commit count, confidence, Jaccard similarity, lift.
- **Author analysis**: Which authors contribute most, which directories have very few contributors (low bus-factor).
- **Git data quality**: Ambiguous and unresolved git files; file resolution statistics.
- **Git author wordcloud**: Visualization of all contributing authors weighted by commit frequency.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [gitHistoryCsv.sh](./gitHistoryCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [gitHistoryPython.sh](./gitHistoryPython.sh): Entry point for Python-based SVG chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [gitHistoryMarkdown.sh](./gitHistoryMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

> **Note:** There is no Visualization entry point — git history analysis generates no GraphViz graph visualizations.

## No-Git-Data Handling

The analyzed codebase may have no git history at all. All entry points handle this gracefully:

- `gitHistoryCsv.sh`: Produces no output if all queries return empty results (cleanup removes empty CSVs). No report directory is created.
- `gitHistoryCharts.py`: Skips chart generation if the report directory or required CSV files are absent. Exits with code 0.
- `gitHistoryMarkdown.sh`: Detects the absence of the report directory and renders `summary/report_no_git_data.template.md` instead.

## Folder Structure

```
domains/git-history/
├── README.md                              # This file
├── PREREQUISITES.md                       # Detailed prerequisite documentation
├── COPIED_FILES.md                        # Original → copy mapping for deprecation follow-up
├── gitHistoryCsv.sh                       # Entry point: CSV reports
├── gitHistoryPython.sh                    # Entry point: Python charts
├── gitHistoryMarkdown.sh                  # Entry point: Markdown summary
├── gitHistoryCharts.py                    # Chart generator: treemap, bar, histogram → SVG
├── explore/                               # Jupyter notebooks for interactive exploration
│   ├── GitHistoryGeneralExploration.ipynb # General exploration (treemaps, charts, wordcloud)
│   └── GitHistoryCorrelationExploration.ipynb # Correlation analysis exploration
├── import/                                # Git data import scripts
│   ├── importGit.sh                       # Git data import orchestrator
│   ├── createGitLogCsv.sh                 # Full git log → CSV
│   └── createAggregatedGitLogCsv.sh       # Aggregated git log → CSV
├── queries/
│   ├── enrichment/                        # 23 Cypher queries: import, indexes, relationships, properties
│   ├── statistics/                        # 14 Cypher queries: listing and querying for reports
│   └── validation/                        # 5 Cypher queries: verification and validation
└── summary/
    ├── gitHistorySummary.sh               # Markdown assembly logic
    ├── report.template.md                 # Main report template
    └── report_no_git_data.template.md     # Fallback: no git data
```

## Prerequisites

This domain requires the following to be in place before running. See [PREREQUISITES.md](./PREREQUISITES.md) for full details.

- Neo4j running with scanned artifacts loaded
- Git history imported (`IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` env var controls the mode)
- `Git:File` ↔ `RESOLVES_TO` ↔ code file relationships
- `CHANGED_TOGETHER_WITH` relationships between git files and resolved code files
- `numberOfGitCommits` property on code `File` nodes
- `updateCommitCount` property on `Git:File` nodes
- `isMergeCommit`, `isAutomatedCommit` classification properties on commits
- General enrichment: `name`, `extension` properties on `File` nodes

## Git Import Modes and Enrichment

The `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` environment variable controls how git data is imported:

| Mode | Description |
|------|-------------|
| `plugin` (default) | jQAssistant git plugin — recommended; schema: `(Git:Commit)-[:CONTAINS_CHANGE]->(Git:Change)-[:UPDATES]->(Git:File)`, property: `relativePath` |
| `full` | CSV git log with every commit — schema: `(Git:Log:Commit)-[:CONTAINS_CHANGED]->(Git:Log:File)`, property: `fileName` |
| `aggregated` | Pre-aggregated CSV git log — no commit-level granularity; `CHANGED_TOGETHER_WITH` cannot be computed |
| `none` | Skip git import entirely |

### CSV `full` Mode Enrichment (`postGitLogImport`)

When `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=full` (CSV mode), the following enrichment steps run in `importGit.sh`:

1. `Set_number_of_git_log_commits.cypher` — sets `numberOfGitCommits` on matching code file nodes.
2. `Set_commit_classification_properties.cypher` — sets `isMergeCommit`, `isAutomatedCommit` on `Git:Log:Commit` nodes.
3. `Set_number_of_git_log_file_update_commits.cypher` — sets `updateCommitCount` on `Git:Log:File` and resolved code file nodes.
4. `Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher` — computes pairwise co-change metrics (confidence, lift, Jaccard, support) and creates `CHANGED_TOGETHER_WITH` relationships between `Git:Log:File` nodes.

The CSV `full` mode queries adapt to the CSV schema (`Git:Log:Commit`, `[:CONTAINS_CHANGED]`, `git_commit.hash`) rather than the plugin schema (`Git:Commit`, `[:CONTAINS_CHANGE]->[:UPDATES]`, `git_commit.sha`). The `commonPostGitImport` function then adds `RESOLVES_TO` relationships and runs validation.

The CSV `full` mode is used automatically when `--skip-jqassistant` is set in `analyze.sh` and a source directory with `.git` is present (default `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=full` from `prepareAnalysis.sh`).

## Output

All output is written to `reports/git-history/` relative to the working directory.

| File | Description |
|------|-------------|
| `List_git_files_with_commit_statistics_by_author.csv` | Per-file commit statistics by author |
| `List_git_files_that_were_changed_together_with_another_file.csv` | Files with co-change partners |
| `List_git_file_directories_with_commit_statistics.csv` | Directory-level commit statistics |
| `List_git_files_per_commit_distribution.csv` | Distribution of changed file counts per commit |
| `List_pairwise_changed_files_with_dependencies.csv` | Co-changed file pairs that also have code dependencies |
| `List_pairwise_changed_files.csv` | All pairwise changed file pairs with co-change metrics |
| `List_pairwise_changed_files_top_count.csv` | Top co-changed pairs by commit count |
| `List_pairwise_changed_files_top_min_confidence.csv` | Top co-changed pairs by min confidence |
| `List_pairwise_changed_files_top_jaccard.csv` | Top co-changed pairs by Jaccard similarity |
| `List_pairwise_changed_files_top_lift.csv` | Top co-changed pairs by lift |
| `List_git_files_by_resolved_label_and_extension.csv` | File resolution statistics |
| `List_ambiguous_git_files.csv` | Data quality: files with ambiguous resolution |
| `List_unresolved_git_files.csv` | Data quality: unresolved git files |
| `Words_for_git_author_Wordcloud_with_frequency.csv` | Author words for wordcloud |
| `*.svg` | SVG chart files generated by `gitHistoryCharts.py` |
| `git_history_report.md` | Final assembled Markdown report |
