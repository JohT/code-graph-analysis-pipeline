# Overview Domain — Copied Files

This document lists the source files copied into this domain and their destination paths.
The copies are kept in sync manually. If the originals change, the copies should be updated accordingly.

## Cypher Queries

| Original | Domain copy |
|----------|-------------|
| [cypher/Overview/Cyclomatic_Method_Complexity_Distribution.cypher](../../cypher/Overview/Cyclomatic_Method_Complexity_Distribution.cypher) | [queries/overview/Cyclomatic_Method_Complexity_Distribution.cypher](./queries/overview/Cyclomatic_Method_Complexity_Distribution.cypher) |
| [cypher/Overview/Dependency_node_labels.cypher](../../cypher/Overview/Dependency_node_labels.cypher) | [queries/overview/Dependency_node_labels.cypher](./queries/overview/Dependency_node_labels.cypher) |
| [cypher/Overview/Effective_lines_of_method_code_per_package.cypher](../../cypher/Overview/Effective_lines_of_method_code_per_package.cypher) | [queries/overview/Effective_lines_of_method_code_per_package.cypher](./queries/overview/Effective_lines_of_method_code_per_package.cypher) |
| [cypher/Overview/Effective_lines_of_method_code_per_type.cypher](../../cypher/Overview/Effective_lines_of_method_code_per_type.cypher) | [queries/overview/Effective_lines_of_method_code_per_type.cypher](./queries/overview/Effective_lines_of_method_code_per_type.cypher) |
| [cypher/Overview/Effective_Method_Line_Count_Distribution.cypher](../../cypher/Overview/Effective_Method_Line_Count_Distribution.cypher) | [queries/overview/Effective_Method_Line_Count_Distribution.cypher](./queries/overview/Effective_Method_Line_Count_Distribution.cypher) |
| [cypher/Overview/Node_label_combination_count.cypher](../../cypher/Overview/Node_label_combination_count.cypher) | [queries/overview/Node_label_combination_count.cypher](./queries/overview/Node_label_combination_count.cypher) |
| [cypher/Overview/Node_label_count.cypher](../../cypher/Overview/Node_label_count.cypher) | [queries/overview/Node_label_count.cypher](./queries/overview/Node_label_count.cypher) |
| [cypher/Overview/Node_labels_and_their_relationships.cypher](../../cypher/Overview/Node_labels_and_their_relationships.cypher) | [queries/overview/Node_labels_and_their_relationships.cypher](./queries/overview/Node_labels_and_their_relationships.cypher) |
| [cypher/Overview/Number_of_elements_per_module_for_Typescript.cypher](../../cypher/Overview/Number_of_elements_per_module_for_Typescript.cypher) | [queries/overview/Number_of_elements_per_module_for_Typescript.cypher](./queries/overview/Number_of_elements_per_module_for_Typescript.cypher) |
| [cypher/Overview/Number_of_packages_per_artifact.cypher](../../cypher/Overview/Number_of_packages_per_artifact.cypher) | [queries/overview/Number_of_packages_per_artifact.cypher](./queries/overview/Number_of_packages_per_artifact.cypher) |
| [cypher/Overview/Number_of_types_per_artifact.cypher](../../cypher/Overview/Number_of_types_per_artifact.cypher) | [queries/overview/Number_of_types_per_artifact.cypher](./queries/overview/Number_of_types_per_artifact.cypher) |
| [cypher/Overview/Overview_size_for_Typescript.cypher](../../cypher/Overview/Overview_size_for_Typescript.cypher) | [queries/overview/Overview_size_for_Typescript.cypher](./queries/overview/Overview_size_for_Typescript.cypher) |
| [cypher/Overview/Overview_size.cypher](../../cypher/Overview/Overview_size.cypher) | [queries/overview/Overview_size.cypher](./queries/overview/Overview_size.cypher) |
| [cypher/Overview/Relationship_type_count.cypher](../../cypher/Overview/Relationship_type_count.cypher) | [queries/overview/Relationship_type_count.cypher](./queries/overview/Relationship_type_count.cypher) |
| [cypher/Overview/Words_for_Wordcloud.cypher](../../cypher/Overview/Words_for_Wordcloud.cypher) | [queries/overview/Words_for_Wordcloud.cypher](./queries/overview/Words_for_Wordcloud.cypher) |

## Jupyter Notebooks

| Original | Domain copy |
|----------|-------------|
| [jupyter/OverviewGeneral.ipynb](../../jupyter/OverviewGeneral.ipynb) | [explore/OverviewGeneralExploration.ipynb](./explore/OverviewGeneralExploration.ipynb) |
| [jupyter/OverviewJava.ipynb](../../jupyter/OverviewJava.ipynb) | [explore/OverviewJavaExploration.ipynb](./explore/OverviewJavaExploration.ipynb) |
| [jupyter/OverviewTypescript.ipynb](../../jupyter/OverviewTypescript.ipynb) | [explore/OverviewTypescriptExploration.ipynb](./explore/OverviewTypescriptExploration.ipynb) |

## Notes on Modifications

The domain copies differ from the originals in the following ways:

- **Cypher paths** in notebooks updated from `../cypher/Overview/` → `../queries/overview/`
- **Notebook metadata** `code_graph_analysis_pipeline_data_validation` changed to `"ValidateAlwaysFalse"` to prevent automatic execution during CI pipeline runs
- **Notebook titles** updated to reflect exploration context (e.g. `"Exploration: Overview in General"`)
- **`overviewCsv.sh`** adds `Overview_size_for_Typescript.cypher` (not present in the original `scripts/reports/OverviewCsv.sh`)
