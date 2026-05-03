# Overview Domain

This directory contains the implementation and resources for generating **overview reports** from the code dependency graph within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, Jupyter notebooks, shell scripts, and report templates needed for this analysis live here.

This domain covers:

- **General graph structure**: Node label combinations, individual node label counts, relationship type distributions, and graph density.
- **Java overview**: Artifact sizes (packages, types, methods, lines of code), type composition (Class, Interface, Enum, Annotation) per artifact, and package count per artifact.
- **TypeScript overview**: Module element counts and element type composition (TypeAlias, Interface, Variable, Function) per module.
- **Interactive exploration**: Jupyter notebooks for exploring the raw overview data and tuning queries interactively.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [overviewCsv.sh](./overviewCsv.sh): Entry point for overview CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [overviewPython.sh](./overviewPython.sh): Entry point for Python-based SVG chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [overviewMarkdown.sh](./overviewMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```
domains/overview/
├── README.md                                # This file
├── PREREQUISITES.md                         # Detailed prerequisite documentation
├── overviewCsv.sh                           # Entry point: CSV report generation
├── overviewPython.sh                        # Entry point: Python SVG chart generation
├── overviewMarkdown.sh                      # Entry point: Markdown summary
├── overviewCharts.py                        # SVG chart generator (reads from Neo4j)
├── explore/                                 # Jupyter notebooks for interactive exploration
│   ├── OverviewGeneralExploration.ipynb
│   ├── OverviewJavaExploration.ipynb
│   └── OverviewTypescriptExploration.ipynb
├── queries/
│   └── overview/                            # 15 Cypher queries (copied from cypher/Overview/)
└── summary/
    ├── overviewSummary.sh                   # Markdown assembly logic
    ├── report.template.md                   # Main report template
    └── report_no_data.template.md           # Fallback when no data is present
```

## Prerequisites

See [PREREQUISITES.md](./PREREQUISITES.md) for full details. Key requirements:

- Neo4j running with scanned code artifacts imported
- `NEO4J_INITIAL_PASSWORD` environment variable set (required by `overviewCharts.py`)
- `effectiveLineCount` and `cyclomaticComplexity` properties on `Method` nodes (set by the jQAssistant Java plugin — not required for TypeScript-only projects)

## Execution Order

1. **`overviewCsv.sh`** — queries Neo4j for overview metrics and writes CSV files
2. **`overviewPython.sh`** — reads data from Neo4j and generates SVG charts (runs step 1 automatically if CSV files are missing)
3. **`overviewMarkdown.sh`** — assembles the final Markdown report from includes and SVG charts

## What This Domain Produces

All output goes into `reports/overview/`:

**CSV files (from `overviewCsv.sh`)**

- `Overview_size.csv` — Java artifact sizes
- `Overview_size_for_Typescript.csv` — TypeScript module sizes
- `Node_label_count.csv` — Count per individual node label
- `Node_label_combination_count.csv` — Count per node label combination
- `Node_labels_and_their_relationships.csv` — Node labels and the relationships between them
- `Relationship_type_count.csv` — Count per relationship type
- `Dependency_node_labels.csv` — Node labels present on external dependency nodes
- `Cyclomatic_Method_Complexity_Distribution.csv` — Distribution of cyclomatic complexity per method
- `Effective_lines_of_method_code_per_package.csv` — Effective LOC aggregated per package
- `Effective_lines_of_method_code_per_type.csv` — Effective LOC aggregated per type
- `Effective_Method_Line_Count_Distribution.csv` — Distribution of effective line counts per method
- `Number_of_packages_per_artifact.csv` — Package count per Java artifact
- `Number_of_types_per_artifact.csv` — Type count per Java artifact
- `Number_of_elements_per_module_for_Typescript.csv` — Element count per TypeScript module

**SVG charts and derived CSVs (from `overviewPython.sh`)**

- `Overview_General_Node_Label_Combination_Count_High.svg` — Pie: label combinations > 0.5%
- `Overview_General_Node_Label_Combination_Count_Low.svg` — Pie: label combinations ≤ 0.5%
- `Overview_General_Node_Label_Count.svg` — 2×2 grid bar: node count by label
- `Overview_General_Relationship_Type_Count_High.svg` — Pie: relationship types > 0.5%
- `Overview_General_Relationship_Type_Count_Low.svg` — Pie: relationship types ≤ 0.5%
- `Overview_General_Graph_Density.csv` — Total nodes, relationships, directed graph density
- `Overview_Java_Types_Per_Artifact_Stacked.svg` — Stacked bar: top 30 artifacts by type count
- `Overview_Java_Class_Types_Per_Artifact_Normalized.svg` — Stacked bar: Class % per artifact
- `Overview_Java_Interface_Types_Per_Artifact_Normalized.svg` — Stacked bar: Interface % per artifact
- `Overview_Java_Enum_Types_Per_Artifact_Normalized.svg` — Stacked bar: Enum % per artifact
- `Overview_Java_Annotation_Types_Per_Artifact_Normalized.svg` — Stacked bar: Annotation % per artifact
- `Overview_Java_Packages_Per_Artifact.svg` — Pie: package count per artifact
- `Java_Types_Per_Artifact_Grouped.csv` — Pivot: types by language element per artifact
- `Java_Types_Per_Artifact_Grouped_Normalized.csv` — Pivot: type % per artifact
- `Overview_Typescript_Elements_Per_Module_Stacked.svg` — Stacked bar: top 30 modules by element count
- `Overview_Typescript_TypeAlias_Elements_Per_Module_Normalized.svg` — Stacked bar: TypeAlias % per module
- `Overview_Typescript_Interface_Elements_Per_Module_Normalized.svg` — Stacked bar: Interface % per module
- `Overview_Typescript_Variable_Elements_Per_Module_Normalized.svg` — Stacked bar: Variable % per module
- `Overview_Typescript_Function_Elements_Per_Module_Normalized.svg` — Stacked bar: Function % per module
- `Typescript_Elements_Per_Module_Grouped.csv` — Pivot: elements by type per module
- `Typescript_Elements_Per_Module_Grouped_Normalized.csv` — Pivot: element % per module

**Markdown report (from `overviewMarkdown.sh`)**

- `overview_report.md` — Assembled Markdown report with tables, CSV links, and embedded SVG charts
