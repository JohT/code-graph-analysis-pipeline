# Copied Files Tracking

This document maps every original file that was copied into this domain to its copy location.
It exists to support a future deprecation follow-up task that will remove or migrate the originals
once this domain is the canonical implementation.

> **Breaking change notice:** Output directories have changed. See the README for the new structure under `reports/internal-dependencies/`.
> When the old scripts in `scripts/reports/` are eventually removed, a **major version bump** is required.

---

## Cypher Queries

### Internal Dependencies (14 files)

| Original | Copy |
|----------|------|
| `cypher/Internal_Dependencies/Candidates_for_Interface_Segregation.cypher` | `queries/internal-dependencies/Candidates_for_Interface_Segregation.cypher` |
| `cypher/Internal_Dependencies/Get_file_distance_as_shortest_contains_path_for_dependencies.cypher` | `queries/internal-dependencies/Get_file_distance_as_shortest_contains_path_for_dependencies.cypher` |
| `cypher/Internal_Dependencies/How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher` | `queries/internal-dependencies/How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher` |
| `cypher/Internal_Dependencies/How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher` | `queries/internal-dependencies/How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher` |
| `cypher/Internal_Dependencies/How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher` | `queries/internal-dependencies/How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher` |
| `cypher/Internal_Dependencies/Inter_scan_and_project_dependencies_of_Typescript_modules.cypher` | `queries/internal-dependencies/Inter_scan_and_project_dependencies_of_Typescript_modules.cypher` |
| `cypher/Internal_Dependencies/Java_Artifact_build_levels_for_graphviz.cypher` | `queries/internal-dependencies/Java_Artifact_build_levels_for_graphviz.cypher` |
| `cypher/Internal_Dependencies/List_all_Java_artifacts.cypher` | `queries/internal-dependencies/List_all_Java_artifacts.cypher` |
| `cypher/Internal_Dependencies/List_all_Typescript_modules.cypher` | `queries/internal-dependencies/List_all_Typescript_modules.cypher` |
| `cypher/Internal_Dependencies/List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher` | `queries/internal-dependencies/List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher` |
| `cypher/Internal_Dependencies/List_types_that_are_used_by_many_different_packages.cypher` | `queries/internal-dependencies/List_types_that_are_used_by_many_different_packages.cypher` |
| `cypher/Internal_Dependencies/NPM_Package_build_levels_for_graphviz.cypher` | `queries/internal-dependencies/NPM_Package_build_levels_for_graphviz.cypher` |
| `cypher/Internal_Dependencies/Set_file_distance_as_shortest_contains_path_for_dependencies.cypher` | `queries/internal-dependencies/Set_file_distance_as_shortest_contains_path_for_dependencies.cypher` |
| `cypher/Internal_Dependencies/Typescript_Module_build_levels_for_graphviz.cypher` | `queries/internal-dependencies/Typescript_Module_build_levels_for_graphviz.cypher` |

### Cyclic Dependencies (7 of 9 files)

Excluded: `Cyclic_Dependencies_Concatenated.cypher` and `Cyclic_Dependencies_as_Nodes.cypher` — unreferenced by any script or notebook.

| Original | Copy |
|----------|------|
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_Breakdown_Backward_Only.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_Breakdown_Backward_Only.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_Breakdown_for_Typescript.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_Breakdown_for_Typescript.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_Breakdown.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_Breakdown.cypher` |
| `cypher/Cyclic_Dependencies/Cyclic_Dependencies_for_Typescript.cypher` | `queries/cyclic-dependencies/Cyclic_Dependencies_for_Typescript.cypher` |

### Path Finding (15 files)

| Original | Copy |
|----------|------|
| `cypher/Path_Finding/Path_Finding_1_Create_Projection.cypher` | `queries/path-finding/Path_Finding_1_Create_Projection.cypher` |
| `cypher/Path_Finding/Path_Finding_2_Estimate_Memory.cypher` | `queries/path-finding/Path_Finding_2_Estimate_Memory.cypher` |
| `cypher/Path_Finding/Path_Finding_3_Depth_First_Search_Path.cypher` | `queries/path-finding/Path_Finding_3_Depth_First_Search_Path.cypher` |
| `cypher/Path_Finding/Path_Finding_4_Breadth_First_Search_Path.cypher` | `queries/path-finding/Path_Finding_4_Breadth_First_Search_Path.cypher` |
| `cypher/Path_Finding/Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher` | `queries/path-finding/Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher` |
| `cypher/Path_Finding/Path_Finding_5_All_pairs_shortest_path_distribution_per_project.cypher` | `queries/path-finding/Path_Finding_5_All_pairs_shortest_path_distribution_per_project.cypher` |
| `cypher/Path_Finding/Path_Finding_5_All_pairs_shortest_path_examples.cypher` | `queries/path-finding/Path_Finding_5_All_pairs_shortest_path_examples.cypher` |
| `cypher/Path_Finding/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher` | `queries/path-finding/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher` |
| `cypher/Path_Finding/Path_Finding_6_Longest_paths_distribution_overall.cypher` | `queries/path-finding/Path_Finding_6_Longest_paths_distribution_overall.cypher` |
| `cypher/Path_Finding/Path_Finding_6_Longest_paths_distribution_per_project.cypher` | `queries/path-finding/Path_Finding_6_Longest_paths_distribution_per_project.cypher` |
| `cypher/Path_Finding/Path_Finding_6_Longest_paths_examples.cypher` | `queries/path-finding/Path_Finding_6_Longest_paths_examples.cypher` |
| `cypher/Path_Finding/Path_Finding_6_Longest_paths_for_graphviz.cypher` | `queries/path-finding/Path_Finding_6_Longest_paths_for_graphviz.cypher` |
| `cypher/Path_Finding/Set_Parameters.cypher` | `queries/path-finding/Set_Parameters.cypher` |
| `cypher/Path_Finding/Set_Parameters_NonDevNpmPackage.cypher` | `queries/path-finding/Set_Parameters_NonDevNpmPackage.cypher` |
| `cypher/Path_Finding/Set_Parameters_Typescript_Module.cypher` | `queries/path-finding/Set_Parameters_Typescript_Module.cypher` |

### Topological Sort (5 files)

| Original | Copy |
|----------|------|
| `cypher/Topological_Sort/Set_Parameters.cypher` | `queries/topological-sort/Set_Parameters.cypher` |
| `cypher/Topological_Sort/Topological_Sort_Exists.cypher` | `queries/topological-sort/Topological_Sort_Exists.cypher` |
| `cypher/Topological_Sort/Topological_Sort_List.cypher` | `queries/topological-sort/Topological_Sort_List.cypher` |
| `cypher/Topological_Sort/Topological_Sort_Query.cypher` | `queries/topological-sort/Topological_Sort_Query.cypher` |
| `cypher/Topological_Sort/Topological_Sort_Write.cypher` | `queries/topological-sort/Topological_Sort_Write.cypher` |

### Exploration Queries (2 files — not executed by CSV entry point)

| Original | Copy |
|----------|------|
| `cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher` | `queries/exploration/Artifacts_with_duplicate_packages.cypher` |
| `cypher/Java/Annotated_code_elements.cypher` | `queries/exploration/Annotated_code_elements.cypher` |

---

## Jupyter Notebooks (4 files)

| Original | Copy | Metadata Change |
|----------|------|-----------------|
| `jupyter/InternalDependenciesJava.ipynb` | `explore/InternalDependenciesJava.ipynb` | `ValidateJavaInternalDependencies` → `ValidateAlwaysFalse` |
| `jupyter/InternalDependenciesTypescript.ipynb` | `explore/InternalDependenciesTypescript.ipynb` | `ValidateTypescriptModuleDependencies` → `ValidateAlwaysFalse` |
| `jupyter/PathFindingJava.ipynb` | `explore/PathFindingJava.ipynb` | `ValidateJavaPackageDependencies` → `ValidateAlwaysFalse` |
| `jupyter/PathFindingTypescript.ipynb` | `explore/PathFindingTypescript.ipynb` | `ValidateTypescriptModuleDependencies` → `ValidateAlwaysFalse` |

---

## Scripts Referenced but NOT Copied (Central Pipeline)

These scripts are sourced from the central `scripts/` directory and are not duplicated:

| Script | Used By |
|--------|---------|
| `scripts/executeQueryFunctions.sh` | All entry point scripts |
| `scripts/projectionFunctions.sh` | CSV, Visualization entry points |
| `scripts/cleanupAfterReportGeneration.sh` | CSV, Python, Visualization, Markdown scripts |
| `scripts/visualization/visualizeQueryResults.sh` | Graph visualization script |
| `scripts/markdown/embedMarkdownIncludes.sh` | Markdown summary script |

---

## Old Scripts to Deprecate (Follow-up Task)

Once this domain is the canonical implementation, the following scripts in `scripts/reports/` can be deprecated:

| Old Script | Replacement |
|-----------|-------------|
| `scripts/reports/InternalDependenciesCsv.sh` | `domains/internal-dependencies/internalDependenciesCsv.sh` |
| `scripts/reports/PathFindingCsv.sh` | `domains/internal-dependencies/internalDependenciesCsv.sh` |
| `scripts/reports/TopologicalSortCsv.sh` | `domains/internal-dependencies/internalDependenciesCsv.sh` |
| `scripts/reports/InternalDependenciesVisualization.sh` | `domains/internal-dependencies/graphs/internalDependenciesGraphs.sh` |
| `scripts/reports/PathFindingVisualization.sh` | `domains/internal-dependencies/graphs/internalDependenciesGraphs.sh` |
