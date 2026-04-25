# Plan: Introduce `java` Domain

Vertical-slice the existing Java analysis (currently spread across `cypher/Java/`, `cypher/Artifact_Dependencies/`, `cypher/Overview/`, and legacy report scripts) into a self-contained `domains/java/` domain. Model on `domains/git-history/` with four entry points: two CSV scripts, Python SVG charts, and Markdown summary. `domains/java/` as self-contained as possible.

---

## Target Directory Structure

```
domains/java/
├── README.md
├── PREREQUISITES.md
├── COPIED_FILES.md
├── javaCsv.sh                          # *Csv.sh: Java code quality CSV reports
├── artifactDependenciesCsv.sh          # *Csv.sh: Artifact dependency CSV reports
├── javaPython.sh                       # *Python.sh: SVG charts
├── javaMarkdown.sh                     # *Markdown.sh: Markdown summary
├── javaCharts.py                       # Chart generation
├── explore/
│   └── MethodMetricsJavaExploration.ipynb
├── queries/
│   ├── enrichment/         (6 files)
│   ├── java-code-quality/  (8 files)
│   ├── artifact-dependencies/ (5 files)
│   ├── method-metrics/     (3 files)
│   ├── exploration/        (2 files)
│   └── validation/         (6 files)
└── summary/
    ├── javaSummary.sh
    ├── report.template.md
    └── report_no_java_data.template.md
```

---

## Phase 1 — Scaffolding & Documentation *(all parallel)*

- [ ] Create directory tree: `domains/java/`, subdirs `queries/enrichment/`, `queries/java-code-quality/`, `queries/artifact-dependencies/`, `queries/method-metrics/`, `queries/exploration/`, `queries/validation/`, `explore/`, `summary/`
- [ ] Create `README.md` — overview, entry-points table, folder structure (mirror `domains/git-history/README.md` format)
- [ ] Create `PREREQUISITES.md` skeleton — filled out fully in Phase 7
- [ ] Create `COPIED_FILES.md` skeleton — finalized in Phase 7
- [ ] Update `AGENTS.md` — add `java` to the domains list

## Phase 2 — Copy Cypher Queries *(all parallel)*

- [ ] `queries/enrichment/` — 6 files:
  - From `cypher/Artifact_Dependencies/`: `Set_number_of_Java_packages_and_types_on_artifacts.cypher`, `Incoming_Java_Artifact_Dependencies.cypher`, `Outgoing_Java_Artifact_Dependencies.cypher`, `Set_maven_artifact_version.cypher`
  - From `cypher/Java/`: `Label_external_types_and_annotations.cypher`, `Remove_external_type_and_annotation_labels.cypher`
- [ ] `queries/java-code-quality/` — 8 files from `cypher/Java/`:
  - `Java_Reflection_usage.cypher`
  - `Java_Reflection_usage_detailed.cypher`
  - `Java_deprecated_element_usage.cypher`
  - `Java_deprecated_element_usage_detailed.cypher`
  - `Annotated_code_elements.cypher`
  - `Annotated_code_elements_per_artifact.cypher`
  - `Spring_Web_Request_Annotations.cypher`
  - `JakartaEE_REST_Annotations.cypher`
- [ ] `queries/artifact-dependencies/` — 5 files from `cypher/Artifact_Dependencies/`:
  - `Most_used_internal_dependencies_acreoss_artifacts.cypher`
  - `Artifacts_with_dependencies_to_other_artifacts.cypher`
  - `Artifacts_with_duplicate_packages.cypher`
  - `Usage_and_spread_of_internal_artifact_dependencies.cypher`
  - `Usage_and_spread_of_internal_artifact_dependents.cypher`
- [ ] `queries/method-metrics/` — 3 files from `cypher/Overview/`:
  - `Effective_Method_Line_Count_Distribution.cypher`
  - `Effective_lines_of_method_code_per_type.cypher`
  - `Effective_lines_of_method_code_per_package.cypher`
- [ ] `queries/exploration/` — 2 files from `cypher/Java/`:
  - `JakartaEE_REST_Annotations_Nodes.cypher`
  - `Get_all_declared_and_inherited_methods_of_a_type.cypher`
- [ ] `queries/validation/` — 6 files from `cypher/Validation/`:
  - `ValidateJavaArtifactDependencies.cypher`
  - `ValidateJavaExternalDependencies.cypher`
  - `ValidateJavaInternalDependencies.cypher`
  - `ValidateJavaMethods.cypher`
  - `ValidateJavaPackageDependencies.cypher`
  - `ValidateJavaTypes.cypher`

**Total copied queries: 30 Cypher files**

## Phase 3 — CSV Entry Point Scripts *(depends on Phase 2)*

- [ ] Create `javaCsv.sh` — modeled on `domains/git-history/gitHistoryCsv.sh`. Execution order:
  1. Enrichment (no CSV output): `queries/enrichment/Label_external_types_and_annotations.cypher`
  2. Code quality (→ `reports/java/`):
     - `Java_Reflection_usage.cypher` → `ReflectionUsage.csv`
     - `Java_Reflection_usage_detailed.cypher` → `ReflectionUsageDetailed.csv`
     - `Java_deprecated_element_usage.cypher` → `DeprecatedElementUsage.csv`
     - `Java_deprecated_element_usage_detailed.cypher` → `DeprecatedElementUsageDetailed.csv`
     - `Annotated_code_elements.cypher` → `AnnotatedCodeElements.csv`
     - `Annotated_code_elements_per_artifact.cypher` → `AnnotatedCodeElementsPerArtifact.csv`
     - `Spring_Web_Request_Annotations.cypher` → `SpringWebRequestAnnotations.csv`
     - `JakartaEE_REST_Annotations.cypher` → `JakartaEE_REST_Annotations.csv`
  3. Method metrics (→ `reports/java/`):
     - `Effective_Method_Line_Count_Distribution.cypher` → `EffectiveMethodLineCountDistribution.csv`
     - `Effective_lines_of_method_code_per_type.cypher` → `EffectiveLinesOfMethodCodePerType.csv`
     - `Effective_lines_of_method_code_per_package.cypher` → `EffectiveLinesOfMethodCodePerPackage.csv`
  4. Cleanup empty files
- [ ] Create `artifactDependenciesCsv.sh` — modeled on `scripts/reports/ArtifactDependenciesCsv.sh` adapted for domain structure. Execution order:
  1. Enrichment (no CSV output):
     - `queries/enrichment/Set_number_of_Java_packages_and_types_on_artifacts.cypher`
     - `queries/enrichment/Incoming_Java_Artifact_Dependencies.cypher`
     - `queries/enrichment/Outgoing_Java_Artifact_Dependencies.cypher`
     - `queries/enrichment/Set_maven_artifact_version.cypher`
  2. Statistics (→ `reports/java/`):
     - `Most_used_internal_dependencies_acreoss_artifacts.cypher` → `MostUsedDependenciesAcrossArtifacts.csv`
     - `Artifacts_with_dependencies_to_other_artifacts.cypher` → `DependenciesAcrossArtifacts.csv`
     - `Artifacts_with_duplicate_packages.cypher` → `DuplicatePackageNamesAcrossArtifacts.csv`
     - `Usage_and_spread_of_internal_artifact_dependencies.cypher` → `InternalArtifactUsageSpreadPerDependency.csv`
     - `Usage_and_spread_of_internal_artifact_dependents.cypher` → `InternalArtifactUsageSpreadPerDependent.csv`
  3. Cleanup empty files

## Phase 4 — Python Charts *(depends on Phase 3)*

- [ ] Create `javaCharts.py` — modeled on `domains/git-history/gitHistoryCharts.py`. Parameters: `--report_directory` (required), `--verbose` (optional). Generates ~14 SVGs in `reports/java/`. Exits code 0 gracefully if no CSVs found.

  **Charts:**
  - Artifact dependencies: most used by packages/types (×2), top artifacts by in/out degree (×2), spread per dependency/dependent (×2)
  - Method metrics: LOC distribution histogram, top types by LOC, top packages by complexity (×3)
  - Code quality: annotation type distribution, deprecated usage by element type, annotated elements per artifact (×3)
  - Framework annotations: Spring endpoints by HTTP method, Jakarta EE endpoints (×2)

- [ ] Create `javaPython.sh` — modeled on `domains/git-history/gitHistoryPython.sh`. Auto-invokes `javaCsv.sh` + `artifactDependenciesCsv.sh` if CSVs missing. Graceful exit (code 0) if no Java data.

## Phase 5 — Exploration Notebook *(parallel with Phase 4)*

- [ ] Copy `jupyter/MethodMetricsJava.ipynb` → `explore/MethodMetricsJavaExploration.ipynb` with three changes:
  1. Add notebook metadata: `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` (prevents auto-execution — see `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb`)
  2. Update title in first markdown cell to add "Exploration" (e.g. "Method Metrics Exploration for Java")
  3. Update Cypher file paths: `../../cypher/Overview/*.cypher` → `../queries/method-metrics/*.cypher`

## Phase 6 — Markdown Summary *(depends on Phases 3 & 4)*

- [ ] Create `summary/javaSummary.sh` — modeled on `domains/git-history/summary/gitHistorySummary.sh`. Functions:
  - `java_front_matter()` — YAML front matter (date, version, dataset)
  - `include_svg_if_exists()` / `include_svgs_matching()` — SVG embed helpers
  - `limit_markdown_table()` — caps tables to 10 rows
  - `cypher_table()` — run query + format as Markdown table
  - `csv_link()` — append CSV download link
  - `assemble_java_report()` — orchestrates all sections, creates `includes/` subdir, embeds via `embedMarkdownIncludes.sh`
- [ ] Create `summary/report.template.md` — 7 sections using `<!-- include:filename.md|fallback.md -->` pattern:
  1. Overview — reading guide
  2. Artifact Dependencies — most used, dependency graph, spread, duplicate packages
  3. Method Metrics — line count distribution, LOC per type, LOC per package
  4. Java Code Quality — reflection usage, deprecated element usage
  5. Annotated Elements — by type, per artifact
  6. Web Framework Annotations — Spring Web, Jakarta EE REST
  7. Glossary
- [ ] Create `summary/report_no_java_data.template.md` — fallback: `⚠️ _No data available — no Java artifacts found in the graph database._`
- [ ] Create `javaMarkdown.sh` — simple delegator to `summary/javaSummary.sh` (mirror `domains/git-history/gitHistoryMarkdown.sh`)

## Phase 7 — Finalize Documentation *(depends on all prior phases)*

- [ ] Complete `PREREQUISITES.md`:
  1. **Neo4j Running** with scanned Java artifacts
  2. **jQAssistant scan completed** — creates `Java:Artifact`, `Java:Package`, `Type`, `Method`, `Field`, `Parameter` nodes
  3. **Central enrichment prerequisite**: `cypher/General_Enrichment/Add_file_name_and_extension.cypher` must run before this domain (provides `name`, `extension` properties used by artifact dependency and method metrics queries; not copied — referenced as prerequisite)
  4. **Own enrichment** — run automatically by entry point scripts:
     - `Set_number_of_Java_packages_and_types_on_artifacts.cypher` — sets `numberOfPackages`, `numberOfTypes` on `Artifact`
     - `Incoming_Java_Artifact_Dependencies.cypher` — sets `incomingDependencies`, `incomingDependenciesWeight`
     - `Outgoing_Java_Artifact_Dependencies.cypher` — sets `outgoingDependencies`, `outgoingDependenciesWeight`
     - `Set_maven_artifact_version.cypher` — sets `version` on Maven artifacts
     - `Label_external_types_and_annotations.cypher` — labels `ExternalType`, `ExternalAnnotation` (requires `byteCodeVersion` property set by jQAssistant)
  5. **Central scripts sourced** (not copied):
     - `scripts/executeQueryFunctions.sh` — `execute_cypher()` function
     - `scripts/cleanupAfterReportGeneration.sh` — delete empty CSVs
     - `scripts/markdown/embedMarkdownIncludes.sh` — Markdown assembly
  6. **Graceful degradation**: If no Java artifacts present, all queries return empty; cleanup removes directory; Markdown renders fallback template.
- [ ] Complete `COPIED_FILES.md` — full mapping table (30 Cypher files + 1 notebook). Breaking-change notice: output dirs change from `reports/java-csv/` and `reports/artifact-dependencies-csv/` → `reports/java/`; major version bump required when originals are eventually removed.
- [ ] Finalize `README.md` — add actual output file list, link to PREREQUISITES.md and COPIED_FILES.md

---

## Relevant Files

- `domains/git-history/gitHistoryCsv.sh` — CSV entry point reference
- `domains/git-history/gitHistoryPython.sh` — Python entry point reference
- `domains/git-history/gitHistoryCharts.py` — charts script reference
- `domains/git-history/gitHistoryMarkdown.sh` — Markdown entry point reference
- `domains/git-history/summary/gitHistorySummary.sh` — summary assembly reference
- `domains/git-history/summary/report.template.md` — report template reference
- `domains/git-history/PREREQUISITES.md` — prerequisites doc reference
- `domains/git-history/COPIED_FILES.md` — copied-files doc reference
- `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb` — `ValidateAlwaysFalse` metadata reference
- `scripts/reports/JavaCsv.sh` — original script (kept, not deleted)
- `scripts/reports/ArtifactDependenciesCsv.sh` — original script (kept, not deleted)
- `cypher/Java/` — 12 source Cypher files (8 code quality + 2 enrichment + 2 exploration)
- `cypher/Artifact_Dependencies/` — 9 source files (4 enrichment + 5 statistics)
- `cypher/Overview/` — 3 Java-specific method metrics queries
- `cypher/Validation/` — 6 Java-specific validation queries
- `jupyter/MethodMetricsJava.ipynb` — source for explore notebook
- `AGENTS.md` — update domains list

---

## Verification

- [ ] `shellcheck domains/java/javaCsv.sh domains/java/artifactDependenciesCsv.sh domains/java/javaPython.sh domains/java/javaMarkdown.sh domains/java/summary/javaSummary.sh`
- [ ] Pylance type checking on `domains/java/javaCharts.py`
- [ ] `analyze.sh --domain java --report Csv --keep-running` — verify `reports/java/` has 11 CSVs from `javaCsv.sh` + 5 from `artifactDependenciesCsv.sh`
- [ ] `analyze.sh --domain java --report Python --keep-running` — verify ~14 SVGs in `reports/java/`
- [ ] `analyze.sh --domain java --report Markdown --keep-running` — verify `reports/java/java_report.md` renders all sections
- [ ] `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/java/README.md domains/java/PREREQUISITES.md`
- [ ] Verify `explore/MethodMetricsJavaExploration.ipynb` has `ValidateAlwaysFalse` in notebook metadata

---

## Decisions & Assumptions

- **Typo in prompt resolved**: "ArtifactDependenciesCsv.sh" was listed twice; interpreted as `JavaCsv.sh` + `ArtifactDependenciesCsv.sh`
- **Notebook scope**: Only `MethodMetricsJava.ipynb` — the sole `jupyter/` notebook with no TypeScript counterpart
- **Two CSV entry points**: `javaCsv.sh` (code quality + method metrics) and `artifactDependenciesCsv.sh` (artifact analysis) — separated by concern
- **Output directory**: `reports/java/` for both (breaking change from legacy scripts; documented in COPIED_FILES.md)
- **No Visualization entry point**: No GraphViz graphs planned for this domain
- **Validation queries not auto-run**: Placed in `queries/validation/` for manual verification use only
- **Scope exclusion**: `cypher/Metrics/` OO design metrics and `cypher/Visibility/` visibility metrics excluded — TypeScript variants exist and are already covered by `internal-dependencies` domain
- **`cypher/Artifact_Dependencies/` is Java-only**: No TypeScript equivalents exist in that directory
- **No move/delete**: Original `scripts/reports/JavaCsv.sh` and `ArtifactDependenciesCsv.sh` remain untouched (copy only)
