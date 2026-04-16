# Copied Files Tracking

This document maps every original file that was copied into this domain to its copy location.
It exists to support a future deprecation follow-up task that will remove or migrate the originals
once this domain is the canonical implementation.

> **Breaking change notice:** Output directory has changed from `reports/git-history-csv` to `reports/git-history`.
> When the old `scripts/reports/GitHistoryCsv.sh` is eventually removed, a **major version bump** is required.

---

## Cypher Queries

### Enrichment Queries (26 files)

| Original | Copy |
|----------|------|
| `cypher/GitLog/Import_git_log_csv_data.cypher` | `queries/enrichment/Import_git_log_csv_data.cypher` |
| `cypher/GitLog/Import_aggregated_git_log_csv_data.cypher` | `queries/enrichment/Import_aggregated_git_log_csv_data.cypher` |
| `cypher/GitLog/Create_git_repository_node.cypher` | `queries/enrichment/Create_git_repository_node.cypher` |
| `cypher/GitLog/Delete_git_log_data.cypher` | `queries/enrichment/Delete_git_log_data.cypher` |
| `cypher/GitLog/Delete_plain_git_directory_file_nodes.cypher` | `queries/enrichment/Delete_plain_git_directory_file_nodes.cypher` |
| `cypher/GitLog/Index_absolute_file_name.cypher` | `queries/enrichment/Index_absolute_file_name.cypher` |
| `cypher/GitLog/Index_author_name.cypher` | `queries/enrichment/Index_author_name.cypher` |
| `cypher/GitLog/Index_change_span_year.cypher` | `queries/enrichment/Index_change_span_year.cypher` |
| `cypher/GitLog/Index_commit_hash.cypher` | `queries/enrichment/Index_commit_hash.cypher` |
| `cypher/GitLog/Index_commit_parent.cypher` | `queries/enrichment/Index_commit_parent.cypher` |
| `cypher/GitLog/Index_commit_sha.cypher` | `queries/enrichment/Index_commit_sha.cypher` |
| `cypher/GitLog/Index_file_name.cypher` | `queries/enrichment/Index_file_name.cypher` |
| `cypher/GitLog/Index_file_relative_path.cypher` | `queries/enrichment/Index_file_relative_path.cypher` |
| `cypher/GitLog/Add_CHANGED_TOGETHER_WITH_relationships_to_code_files.cypher` | `queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_code_files.cypher` |
| `cypher/GitLog/Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher` | `queries/enrichment/Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher` |
| `cypher/GitLog/Add_HAS_PARENT_relationships_to_commits.cypher` | `queries/enrichment/Add_HAS_PARENT_relationships_to_commits.cypher` |
| `cypher/GitLog/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher` | `queries/enrichment/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher` |
| `cypher/GitLog/Add_RESOLVES_TO_relationships_to_git_files_for_Typescript.cypher` | `queries/enrichment/Add_RESOLVES_TO_relationships_to_git_files_for_Typescript.cypher` |
| `cypher/GitLog/Set_commit_classification_properties.cypher` | `queries/enrichment/Set_commit_classification_properties.cypher` |
| `cypher/GitLog/Set_number_of_aggregated_git_commits.cypher` | `queries/enrichment/Set_number_of_aggregated_git_commits.cypher` |
| `cypher/GitLog/Set_number_of_git_log_commits.cypher` | `queries/enrichment/Set_number_of_git_log_commits.cypher` |
| `cypher/GitLog/Set_number_of_git_plugin_commits.cypher` | `queries/enrichment/Set_number_of_git_plugin_commits.cypher` |
| `cypher/GitLog/Set_number_of_git_plugin_update_commits.cypher` | `queries/enrichment/Set_number_of_git_plugin_update_commits.cypher` |

> **Note:** Only 23 enrichment query files are listed above. The remaining 5 files (Verify_*) were placed in `validation/`.
> The total enrichment file count includes import, repository, deletion (2), indexes (8), relationships (5), properties (5) = 23 unique files.

### Statistics Queries (14 files)

| Original | Copy |
|----------|------|
| `cypher/GitLog/List_ambiguous_git_files.cypher` | `queries/statistics/List_ambiguous_git_files.cypher` |
| `cypher/GitLog/List_git_file_directories_with_commit_statistics.cypher` | `queries/statistics/List_git_file_directories_with_commit_statistics.cypher` |
| `cypher/GitLog/List_git_files_by_resolved_label_and_extension.cypher` | `queries/statistics/List_git_files_by_resolved_label_and_extension.cypher` |
| `cypher/GitLog/List_git_files_per_commit_distribution.cypher` | `queries/statistics/List_git_files_per_commit_distribution.cypher` |
| `cypher/GitLog/List_git_files_that_were_changed_together.cypher` | `queries/statistics/List_git_files_that_were_changed_together.cypher` |
| `cypher/GitLog/List_git_files_that_were_changed_together_all_in_one.cypher` | `queries/statistics/List_git_files_that_were_changed_together_all_in_one.cypher` |
| `cypher/GitLog/List_git_files_that_were_changed_together_with_another_file.cypher` | `queries/statistics/List_git_files_that_were_changed_together_with_another_file.cypher` |
| `cypher/GitLog/List_git_files_that_were_changed_together_with_another_file_all_in_one.cypher` | `queries/statistics/List_git_files_that_were_changed_together_with_another_file_all_in_one.cypher` |
| `cypher/GitLog/List_git_files_with_commit_statistics_by_author.cypher` | `queries/statistics/List_git_files_with_commit_statistics_by_author.cypher` |
| `cypher/GitLog/List_pairwise_changed_files.cypher` | `queries/statistics/List_pairwise_changed_files.cypher` |
| `cypher/GitLog/List_pairwise_changed_files_top_selected_metric.cypher` | `queries/statistics/List_pairwise_changed_files_top_selected_metric.cypher` |
| `cypher/GitLog/List_pairwise_changed_files_with_dependencies.cypher` | `queries/statistics/List_pairwise_changed_files_with_dependencies.cypher` |
| `cypher/GitLog/List_unresolved_git_files.cypher` | `queries/statistics/List_unresolved_git_files.cypher` |
| `cypher/Overview/Words_for_git_author_Wordcloud_with_frequency.cypher` | `queries/statistics/Words_for_git_author_Wordcloud_with_frequency.cypher` |

### Validation Queries (5 files)

| Original | Copy |
|----------|------|
| `cypher/GitLog/Verify_code_to_git_file_unambiguous.cypher` | `queries/validation/Verify_code_to_git_file_unambiguous.cypher` |
| `cypher/GitLog/Verify_git_missing_CHANGED_TOGETHER_WITH_properties.cypher` | `queries/validation/Verify_git_missing_CHANGED_TOGETHER_WITH_properties.cypher` |
| `cypher/GitLog/Verify_git_missing_create_date.cypher` | `queries/validation/Verify_git_missing_create_date.cypher` |
| `cypher/GitLog/Verify_git_to_code_file_unambiguous.cypher` | `queries/validation/Verify_git_to_code_file_unambiguous.cypher` |
| `cypher/Validation/ValidateGitHistory.cypher` | `queries/validation/ValidateGitHistory.cypher` |

---

## Import Scripts (3 files)

| Original | Copy | Changes |
|----------|------|---------|
| `scripts/importGit.sh` | `import/importGit.sh` | Updated `GIT_LOG_CYPHER_DIR` to `../queries/enrichment/`; updated sourced script paths |
| `scripts/createGitLogCsv.sh` | `import/createGitLogCsv.sh` | No changes |
| `scripts/createAggregatedGitLogCsv.sh` | `import/createAggregatedGitLogCsv.sh` | No changes |

---

## Jupyter Notebooks (2 files)

| Original | Copy | Metadata Change |
|----------|------|-----------------|
| `jupyter/GitHistoryGeneral.ipynb` | `explore/GitHistoryGeneralExploration.ipynb` | Added `"ValidateAlwaysFalse"` metadata; updated cypher paths; changed title |
| `jupyter/GitHistoryExploration.ipynb` | `explore/GitHistoryCorrelationExploration.ipynb` | Added `"ValidateAlwaysFalse"` metadata; updated cypher paths; changed title |

---

## Scripts Referenced but NOT Copied (Central Pipeline)

These scripts are sourced from the central `scripts/` directory and are not duplicated:

| Script | Domain Usage |
|--------|-------------|
| `scripts/executeQueryFunctions.sh` | Sourced by all entry point scripts |
| `scripts/cleanupAfterReportGeneration.sh` | Sourced by CSV entry point after report generation |
| `scripts/markdown/embedMarkdownIncludes.sh` | Sourced by summary script for Markdown assembly |
