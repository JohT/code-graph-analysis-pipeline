# Git History Domain — Prerequisites

The following are provided by the central pipeline and must run **before** this domain executes.
They are not copied into this domain; they are sourced or referenced from the central pipeline locations.

---

## 1. Neo4j Running with Scanned Artifacts

Neo4j must be running and all artifacts must have been scanned and loaded into the graph database
before any script in this domain is executed.

See the main [README.md](../../README.md) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

---

## 2. Git History Imported

Git history data must have been imported into the graph database. Controlled by the environment variable:

```
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="plugin"  # Recommended default
```

Options: `"none"`, `"aggregated"`, `"full"`, `"plugin"` (default).

- **`plugin`** (recommended): jQAssistant git plugin provides `Git:Commit`, `Git:File`, `Git:Author`, and related nodes.
- **`full`**: Full git log CSV import via `createGitLogCsv.sh`.
- **`aggregated`**: Aggregated git log CSV import via `createAggregatedGitLogCsv.sh`.
- **`none`**: Skip git import.

The domain's `import/importGit.sh` script orchestrates this import.

> **Note:** The analyzed codebase may have no git history at all.
> All domain entry points handle this case gracefully: `gitHistoryCsv.sh` produces no output
> when all queries are empty; `gitHistoryCharts.py` skips chart generation if CSV files are absent;
> `gitHistoryMarkdown.sh` renders a fallback report if no report directory is found.

---

## 3. Git:File ↔ Code File Relationships

The following relationships must exist (created by `import/importGit.sh`):

| Relationship | Description |
|---|---|
| `(Git:File)-[:RESOLVES_TO]->(File)` | Links git-tracked files to scanned Java/TypeScript code files |
| `(File)-[:CHANGED_TOGETHER_WITH]->(File)` | Co-change relationships between resolved code files |
| `(Git:File)-[:CHANGED_TOGETHER_WITH]->(Git:File)` | Co-change relationships between raw git files |

---

## 4. Required Properties

| Property | Node | Set By |
|---|---|---|
| `numberOfGitCommits` | `File` (Java/TypeScript) | `Set_number_of_git_log_commits.cypher` or `Set_number_of_git_plugin_commits.cypher` |
| `updateCommitCount` | `Git:File` | `Set_number_of_git_plugin_update_commits.cypher` |
| `isMergeCommit` | `Git:Commit` | `Set_commit_classification_properties.cypher` |
| `isAutomatedCommit` | `Git:Commit` | `Set_commit_classification_properties.cypher` |

---

## 5. General Enrichment

The `name` and `extension` properties on `File` nodes must be set by the general enrichment queries:

**Cypher source:** [`cypher/General_Enrichment/`](../../cypher/General_Enrichment/)

---

## 6. Central Pipeline Scripts (sourced, not copied)

| Script | Purpose |
|---|---|
| `scripts/executeQueryFunctions.sh` | Provides `execute_cypher()` and `execute_cypher_queries_until_results()` functions |
| `scripts/cleanupAfterReportGeneration.sh` | Removes empty CSV files after report generation |
| `scripts/markdown/embedMarkdownIncludes.sh` | Assembles Markdown includes into the final report |
