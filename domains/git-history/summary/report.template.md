<!-- include:GitHistoryReportFrontMatter.md -->

# 📜 Git History Report

## 1. Overview

This report analyses the **git commit history** of the codebase. It covers:

- **Directory commit statistics** — which directories change most frequently and by how many authors
- **Co-changed files** — files that are frequently committed together (coupling signals)
- **File change distribution** — how many files are changed per commit
- **Pairwise changed files** — direct co-change relationships between specific file pairs
- **Data quality** — ambiguous or unresolved file references in the git log
- **Git author wordcloud** — visual overview of contributor activity

> **Reading the tables**: Rows are sorted by priority — the **first rows are the most critical**.  
> High commit frequency in a directory can indicate hotspots that benefit from refactoring attention.  
> Files that always change together may be candidates for co-location or module consolidation.

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [Directory Commit Statistics](#2-directory-commit-statistics)
1. [Co-Changed Files](#3-co-changed-files)
1. [File Change Distribution](#4-file-change-distribution)
1. [Pairwise Changed Files](#5-pairwise-changed-files)
1. [Files by Author](#6-files-by-author)
1. [Data Quality](#7-data-quality)
1. [Git Author Wordcloud](#8-git-author-wordcloud)
1. [Glossary and Column Definitions](#9-glossary-and-column-definitions)

---

## 2. Directory Commit Statistics

Shows how often each directory has been changed in git history and how many distinct authors contributed to it. High values in `commits` and `authors` point to active, potentially complex directories.

### 2.1 Directory Commit Statistics (Table)

<!-- include:List_git_file_directories_with_commit_statistics.md|report_no_git_data.template.md -->

### 2.2 Directory Commit Statistics (Charts)

<!-- include:DirectoryCommitStatisticsCharts.md|empty.md -->

---

## 3. Co-Changed Files

Files that are frequently committed together are said to be _co-changed_. High co-change frequency between two files is a signal of logical coupling — they may belong to the same conceptual unit or have a shared concern that could be refactored.

### 3.1 Co-Changed File Pairs

<!-- include:List_git_files_that_were_changed_together.md|report_no_git_data.template.md -->

### 3.2 Co-Changed File Pairs (All in One Commit)

Files changed together in a single large commit.

<!-- include:List_git_files_that_were_changed_together_all_in_one.md|report_no_git_data.template.md -->

### 3.3 Co-Changed With a Specific File

Shows all files that were changed together with another particular file.

<!-- include:List_git_files_that_were_changed_together_with_another_file.md|report_no_git_data.template.md -->

### 3.4 Co-Changed With a Specific File (All in One)

<!-- include:List_git_files_that_were_changed_together_with_another_file_all_in_one.md|report_no_git_data.template.md -->

### 3.5 Co-Changed Files (Charts)

<!-- include:CoChangedFilesCharts.md|empty.md -->

---

## 4. File Change Distribution

Shows the distribution of how many files are changed per commit. A high proportion of large commits (many files changed at once) can indicate low commit granularity.

### 4.1 Files per Commit Distribution

<!-- include:List_git_files_per_commit_distribution.md|report_no_git_data.template.md -->

### 4.2 Files per Commit Chart

<!-- include:FilesPerCommitChart.md|empty.md -->

---

## 5. Pairwise Changed Files

Direct pairwise co-change analysis between individual files, showing commit overlap counts and related dependency information.

### 5.1 Pairwise Changed Files

<!-- include:List_pairwise_changed_files.md|report_no_git_data.template.md -->

### 5.2 Pairwise Changed Files (Top by Lift)

Filing pairs with the highest _commit lift_ — pairs that co-change more often than random chance (lift > 1).

<!-- include:List_pairwise_changed_files_top_selected_metric.md|report_no_git_data.template.md -->

### 5.3 Pairwise Changed Files With Dependencies

Files that are co-changed and also have a structural dependency relationship between them.

<!-- include:List_pairwise_changed_files_with_dependencies.md|report_no_git_data.template.md -->

### 5.4 Pairwise Changed Files (Charts)

<!-- include:PairwiseChangedFilesCharts.md|empty.md -->

---

## 6. Files by Author

Shows the files each author has contributed to, including per-author commit statistics per file. Useful for identifying knowledge boundaries and bus-factor risks.

### 6.1 Files with Commit Statistics by Author

<!-- include:List_git_files_with_commit_statistics_by_author.md|report_no_git_data.template.md -->

---

## 7. Data Quality

Identifies potential issues in the git log data: files referenced in commits that cannot be resolved to a known codebase file (unresolved), or that match more than one candidate (ambiguous). These affect the reliability of all co-change metrics.

### 7.1 File Resolution Summary

Overview of file resolution by extension: how many files are resolved vs. ambiguous vs. unresolved per file type.

<!-- include:List_git_files_by_resolved_label_and_extension.md|report_no_git_data.template.md -->

### 7.2 Ambiguous Git Files

Files in the git log that match multiple candidates in the scanned codebase. These are excluded from co-change analysis.

<!-- include:List_ambiguous_git_files.md|report_no_git_data.template.md -->

### 7.3 Unresolved Git Files

Files referenced in git commits but not found in the scanned codebase. May indicate deleted files, renames, or files outside the scan scope.

<!-- include:List_unresolved_git_files.md|report_no_git_data.template.md -->

---

## 8. Git Author Wordcloud

Visual overview of contributor names by commit frequency. Larger text = more commits.

<!-- include:GitAuthorWordcloudChart.md|empty.md -->

---

## 9. Glossary and Column Definitions

| Term | Definition |
|------|------------|
| `commits` | Number of git commits touching this file or directory. |
| `authors` | Number of distinct author identities contributing to this file or directory. |
| `coChanges` | Number of commits in which two files were changed together. |
| `coupling` | Ratio of co-changes to total commits (0–1). Higher = tighter logical coupling. |
| `coChangedWith` | The other file in a co-change pair. |
| `ambiguous` | A git file path that matches more than one node in the scanned codebase. |
| `unresolved` | A git file path that matches no node in the scanned codebase. |
| `filesPerCommit` | How many files were changed in a single commit. |
| `frequency` | Relative share of commits at a specific `filesPerCommit` count. |
