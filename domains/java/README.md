# Java Domain

This directory contains the implementation and resources for analysing **Java code** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, shell scripts, and report templates needed for this analysis live here.

This domain covers all Java code analysis areas:

- **Artifact dependencies**: Which Maven artifacts depend on which others, the most widely-used internal modules, and artifacts with duplicate package names.
- **Method metrics**: Effective lines of method code per type and per package, and the distribution of method line counts across the codebase.
- **Java code quality**: Annotation usage across the codebase, deprecated API usages, and reflection calls.
- **Web framework annotations**: Spring Web and Jakarta EE REST HTTP mapping annotations (endpoint declarations).

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [javaCsv.sh](./javaCsv.sh): Entry point for Java code quality and method metrics CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [artifactDependenciesCsv.sh](./artifactDependenciesCsv.sh): Entry point for artifact dependency CSV reports. Also discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [javaPython.sh](./javaPython.sh): Entry point for Python-based SVG chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [javaMarkdown.sh](./javaMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

> **Note:** There is no Visualization entry point — Java analysis generates no GraphViz graph visualizations.

## No-Java-Data Handling

The analyzed codebase may contain no Java artifacts. All entry points handle this gracefully:

- `javaCsv.sh` and `artifactDependenciesCsv.sh`: Produce no output if all queries return empty results (`cleanupAfterReportGeneration.sh` removes empty CSVs). No report directory is created.
- `javaCharts.py`: Skips chart generation if the report directory or required CSV files are absent. Exits with code 0.
- `javaMarkdown.sh`: Renders `summary/report_no_java_data.template.md` via the `<!-- include:...|report_no_java_data.template.md -->` fallback when no data sections are present.

## Folder Structure

```
domains/java/
├── README.md                                      # This file
├── PREREQUISITES.md                               # Detailed prerequisite documentation
├── COPIED_FILES.md                                # Original → copy mapping for deprecation follow-up
├── javaCsv.sh                                     # Entry point: Java code quality + method metrics CSV reports
├── artifactDependenciesCsv.sh                     # Entry point: artifact dependency CSV reports
├── javaPython.sh                                  # Entry point: Python SVG chart generation
├── javaMarkdown.sh                                # Entry point: Markdown summary report
├── javaCharts.py                                  # Chart generator: horizontal bar charts → SVG
├── explore/
│   └── MethodMetricsJavaExploration.ipynb         # Jupyter notebook for interactive method metrics exploration
├── queries/
│   ├── enrichment/                                # 2 Cypher queries: set properties on artifacts
│   ├── artifact-dependencies/                     # 7 Cypher queries: incoming/outgoing dependencies, spread, duplicates
│   ├── java-code-quality/                         # 8 Cypher queries: annotations, deprecated usages, reflection, web frameworks
│   ├── method-metrics/                            # 3 Cypher queries: LOC per type, per package, distribution
│   ├── exploration/                               # 2 Cypher queries: interactive exploration helpers
│   └── validation/                               # 6 Cypher queries: jQAssistant validation constraints
└── summary/
    ├── javaSummary.sh                             # Markdown assembly logic
    ├── report.template.md                         # Main report template
    └── report_no_java_data.template.md            # Fallback: no Java data
```

## Prerequisites

This domain requires the following to be in place before running. See [PREREQUISITES.md](./PREREQUISITES.md) for full details.

- Neo4j running with scanned Java artifacts loaded
- General enrichment run (`cypher/General_Enrichment/`)
- Own enrichment runs automatically (sets properties on artifact nodes)

## Output

All output is written to `reports/java/` relative to the working directory.

| File | Description |
|------|-------------|
| `IncomingDependencies.csv` | Artifacts ranked by number of incoming dependencies |
| `OutgoingDependencies.csv` | Artifacts ranked by number of outgoing dependencies |
| `MostUsedDependenciesAcrossArtifacts.csv` | Most used internal dependencies by dependent artifact count |
| `DependenciesAcrossArtifacts.csv` | All artifact dependency relationships |
| `DuplicatePackageNamesAcrossArtifacts.csv` | Package names appearing in more than one artifact |
| `InternalArtifactUsageSpreadPerDependency.csv` | Internal artifacts most widely depended upon |
| `InternalArtifactUsageSpreadPerDependent.csv` | Internal artifacts that depend on the most others |
| `ReflectionUsage.csv` | Callers of Java Reflection API methods |
| `ReflectionUsageDetailed.csv` | Detailed reflection usage including call context |
| `DeprecatedElementUsage.csv` | Usages of deprecated classes, methods, or fields |
| `DeprecatedElementUsageDetailed.csv` | Detailed deprecated element usages |
| `AnnotatedCodeElements.csv` | Code elements annotated with each annotation type |
| `AnnotatedCodeElementsPerArtifact.csv` | Annotated elements grouped by artifact |
| `SpringWebRequestAnnotations.csv` | Spring Web HTTP mapping annotations per method |
| `JakartaEE_REST_Annotations.csv` | Jakarta EE REST HTTP method annotations per method |
| `EffectiveMethodLineCountDistribution.csv` | Distribution of effective method line counts |
| `EffectiveLinesOfMethodCodePerType.csv` | Total effective method LOC per Java type |
| `EffectiveLinesOfMethodCodePerPackage.csv` | Total effective method LOC per Java package |
| `ArtifactDependencies_IncomingTop20_Bar.svg` | Top 20 artifacts by incoming dependency count |
| `ArtifactDependencies_OutgoingTop20_Bar.svg` | Top 20 artifacts by outgoing dependency count |
| `ArtifactDependencies_MostUsedTop20_Bar.svg` | Top 20 most used internal dependencies |
| `ArtifactDependencies_SpreadPerDependency_Bar.svg` | Top 20 internal dependencies by usage spread |
| `ArtifactDependencies_SpreadPerDependent_Bar.svg` | Top 20 internal artifacts by dependent spread |
| `MethodMetrics_LineCountDistribution_Histogram.svg` | Effective method line count distribution histogram |
| `MethodMetrics_TopTypesLOC_Bar.svg` | Top 20 types by effective lines of method code |
| `MethodMetrics_TopPackagesLOC_Bar.svg` | Top 20 packages by effective lines of method code |
| `JavaCodeQuality_AnnotationTypeDistribution_Bar.svg` | Top 15 annotations by usage count |
| `JavaCodeQuality_AnnotatedElementsPerArtifact_Bar.svg` | Top 20 artifacts by annotated element count |
| `JavaCodeQuality_DeprecatedElementUsageTop20_Bar.svg` | Top 20 most used deprecated elements |
| `WebFrameworks_SpringEndpointsByAnnotation_Bar.svg` | Spring Web endpoints by HTTP mapping annotation |
| `WebFrameworks_JakartaEEEndpointsByAnnotation_Bar.svg` | Jakarta EE REST endpoints by HTTP method annotation |
| `java_report.md` | Final assembled Markdown report |
