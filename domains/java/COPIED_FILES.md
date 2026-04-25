# Copied Files Tracking

This document maps every original file that was copied into this domain to its copy location.
It exists to support a future deprecation follow-up task that will remove or migrate the originals
once this domain is the canonical implementation.

> **Breaking change notice:** Output directory has changed from `reports/java-csv/` and `reports/artifact-dependencies-csv/` to `reports/java/`.
> When the old `scripts/reports/JavaCsv.sh` and `scripts/reports/ArtifactDependenciesCsv.sh` are eventually removed, a **major version bump** is required.

---

## Cypher Queries

### Enrichment Queries (2 files)

| Original | Copy |
|----------|------|
| `cypher/Artifact_Dependencies/Set_number_of_Java_packages_and_types_on_artifacts.cypher` | `queries/enrichment/Set_number_of_Java_packages_and_types_on_artifacts.cypher` |
| `cypher/Artifact_Dependencies/Set_maven_artifact_version.cypher` | `queries/enrichment/Set_maven_artifact_version.cypher` |

### Artifact Dependency Queries (7 files)

| Original | Copy |
|----------|------|
| `cypher/Artifact_Dependencies/Incoming_Java_Artifact_Dependencies.cypher` | `queries/artifact-dependencies/Incoming_Java_Artifact_Dependencies.cypher` |
| `cypher/Artifact_Dependencies/Outgoing_Java_Artifact_Dependencies.cypher` | `queries/artifact-dependencies/Outgoing_Java_Artifact_Dependencies.cypher` |
| `cypher/Artifact_Dependencies/Most_used_internal_dependencies_acreoss_artifacts.cypher` | `queries/artifact-dependencies/Most_used_internal_dependencies_across_artifacts.cypher` |
| `cypher/Artifact_Dependencies/Artifacts_with_dependencies_to_other_artifacts.cypher` | `queries/artifact-dependencies/Artifacts_with_dependencies_to_other_artifacts.cypher` |
| `cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher` | `queries/artifact-dependencies/Artifacts_with_duplicate_packages.cypher` |
| `cypher/Artifact_Dependencies/Usage_and_spread_of_internal_artifact_dependencies.cypher` | `queries/artifact-dependencies/Usage_and_spread_of_internal_artifact_dependencies.cypher` |
| `cypher/Artifact_Dependencies/Usage_and_spread_of_internal_artifact_dependents.cypher` | `queries/artifact-dependencies/Usage_and_spread_of_internal_artifact_dependents.cypher` |

### Java Code Quality Queries (8 files)

| Original | Copy |
|----------|------|
| `cypher/Java/Java_Reflection_usage.cypher` | `queries/java-code-quality/Java_Reflection_usage.cypher` |
| `cypher/Java/Java_Reflection_usage_detailed.cypher` | `queries/java-code-quality/Java_Reflection_usage_detailed.cypher` |
| `cypher/Java/Java_deprecated_element_usage.cypher` | `queries/java-code-quality/Java_deprecated_element_usage.cypher` |
| `cypher/Java/Java_deprecated_element_usage_detailed.cypher` | `queries/java-code-quality/Java_deprecated_element_usage_detailed.cypher` |
| `cypher/Java/Annotated_code_elements.cypher` | `queries/java-code-quality/Annotated_code_elements.cypher` |
| `cypher/Java/Annotated_code_elements_per_artifact.cypher` | `queries/java-code-quality/Annotated_code_elements_per_artifact.cypher` |
| `cypher/Java/Spring_Web_Request_Annotations.cypher` | `queries/java-code-quality/Spring_Web_Request_Annotations.cypher` |
| `cypher/Java/JakartaEE_REST_Annotations.cypher` | `queries/java-code-quality/JakartaEE_REST_Annotations.cypher` |

### Method Metrics Queries (3 files)

| Original | Copy |
|----------|------|
| `cypher/Overview/Effective_Method_Line_Count_Distribution.cypher` | `queries/method-metrics/Effective_Method_Line_Count_Distribution.cypher` |
| `cypher/Overview/Effective_lines_of_method_code_per_type.cypher` | `queries/method-metrics/Effective_lines_of_method_code_per_type.cypher` |
| `cypher/Overview/Effective_lines_of_method_code_per_package.cypher` | `queries/method-metrics/Effective_lines_of_method_code_per_package.cypher` |

### Exploration Queries (2 files)

| Original | Copy |
|----------|------|
| `cypher/Java/JakartaEE_REST_Annotations_Nodes.cypher` | `queries/exploration/JakartaEE_REST_Annotations_Nodes.cypher` |
| `cypher/Java/Get_all_declared_and_inherited_methods_of_a_type.cypher` | `queries/exploration/Get_all_declared_and_inherited_methods_of_a_type.cypher` |

### Validation Queries (6 files)

| Original | Copy |
|----------|------|
| `cypher/Validation/ValidateJavaArtifactDependencies.cypher` | `queries/validation/ValidateJavaArtifactDependencies.cypher` |
| `cypher/Validation/ValidateJavaExternalDependencies.cypher` | `queries/validation/ValidateJavaExternalDependencies.cypher` |
| `cypher/Validation/ValidateJavaInternalDependencies.cypher` | `queries/validation/ValidateJavaInternalDependencies.cypher` |
| `cypher/Validation/ValidateJavaMethods.cypher` | `queries/validation/ValidateJavaMethods.cypher` |
| `cypher/Validation/ValidateJavaPackageDependencies.cypher` | `queries/validation/ValidateJavaPackageDependencies.cypher` |
| `cypher/Validation/ValidateJavaTypes.cypher` | `queries/validation/ValidateJavaTypes.cypher` |

---

## Jupyter Notebooks (1 file)

| Original | Copy | Changes |
|----------|------|---------|
| `jupyter/MethodMetricsJava.ipynb` | `explore/MethodMetricsJavaExploration.ipynb` | Added `code_graph_analysis_pipeline_data_validation: ValidateAlwaysFalse` metadata; updated title to `# Method Metrics Exploration for Java` |
