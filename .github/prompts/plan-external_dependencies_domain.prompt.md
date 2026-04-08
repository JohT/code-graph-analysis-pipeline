## Plan: Create External Dependencies Domain

Create a new self-contained `domains/external-dependencies/` domain following the `anomaly-detection` reference pattern. Copy all 35 Cypher queries, the existing CSV shell script, convert both Jupyter notebooks (Java + TypeScript) to a Python SVG chart generator, move the notebooks to an `explore/` folder with validation disabled, and assemble a Markdown summary report optimized for human and AI agent consumption. No moves or deletions of originals. No graph visualizations yet.

### Decisions

- **ExternalDependenciesCsv.sh**: Keep both (original in [scripts/reports/ExternalDependenciesCsv.sh](scripts/reports/ExternalDependenciesCsv.sh) unchanged, copy in domain)
- **Cypher files**: Copy all 35 into domain for self-containment
- **Charts**: ALL charts from both notebooks converted to Python SVG output (~38 total)
- **Package.json queries**: Included in domain
- **Reset folder**: Not included (external type labels are a central enrichment prerequisite)
- **Markdown summary**: Rich, AI-agent-actionable descriptions with architectural guidance
- **Entry point naming**: camelCase prefix (`externalDependenciesCsv.sh`, etc.)

### Prerequisites (Documented in README, Not Copied)

The following are provided by the central pipeline and must run *before* this domain:

1. **Neo4j running** with scanned artifacts loaded
2. **DEPENDS_ON relationships** between types (jQAssistant scan)
3. **Type labels** ([cypher/Types/](cypher/Types/)): base Java types, built-in types, resolved duplicates
4. **Weight properties** on DEPENDS_ON ([cypher/DependsOn_Relationship_Weights/](cypher/DependsOn_Relationship_Weights/)): `weight`, `weightInterfaces`
5. **TypeScript enrichment** ([cypher/Typescript_Enrichment/](cypher/Typescript_Enrichment/)): module properties, namespace, `isNodeModule`, `IS_IMPLEMENTED_IN` resolution, npm linking
6. **General enrichment** ([cypher/General_Enrichment/](cypher/General_Enrichment/)): file name/extension properties

### Domain Directory Structure

```
domains/external-dependencies/
├── README.md
├── externalDependenciesCsv.sh                       # Entry point: CSV reports (*Csv.sh)
├── externalDependenciesPython.sh                    # Entry point: Python charts (*Python.sh)
├── externalDependenciesMarkdown.sh                  # Entry point: Markdown summary (*Markdown.sh)
├── externalDependencyCharts.py                      # Chart generation: pie, bar, scatter → SVG
├── explore/
│   ├── ExternalDependenciesJava.ipynb               # Original notebook (ValidateAlwaysFalse)
│   └── ExternalDependenciesTypescript.ipynb          # Original notebook (ValidateAlwaysFalse)
├── queries/
│   └── (all 35 .cypher files from cypher/External_Dependencies/)
└── summary/
    ├── externalDependenciesSummary.sh               # Markdown assembly logic
    └── report.template.md                           # Main report template
```

---

### Steps

#### Phase 1: Scaffolding & Cypher Queries

**1.1** Create domain directory structure with all subdirectories.

**1.2** Copy all 35 `.cypher` files from [cypher/External_Dependencies/](cypher/External_Dependencies/) into `domains/external-dependencies/queries/`.

**1.3** Create `README.md` — domain overview, prerequisites, entry points, folder structure (matching [anomaly-detection README](domains/anomaly-detection/README.md) format).

#### Phase 2: CSV Entry Point Script

**2.1** Create `externalDependenciesCsv.sh`:
- Follow exact boilerplate pattern of [anomalyDetectionCsv.sh](domains/anomaly-detection/anomalyDetectionCsv.sh) (BASH_SOURCE/CDPATH, `set -o errexit -o pipefail`, script directory resolution)
- Source `../../scripts/executeQueryFunctions.sh` for `execute_cypher()` and `execute_cypher_queries_until_results()`
- Source `../../scripts/cleanupAfterReportGeneration.sh` for cleanup
- Report directory: `reports/external-dependencies`
- First check/create ExternalType labels, then execute all 24+ queries → CSV files
- Replicate query ordering from [ExternalDependenciesCsv.sh](scripts/reports/ExternalDependenciesCsv.sh)

#### Phase 3: Python Chart Generation Script (*parallel with Phase 4*)

**3.1** Create `externalDependencyCharts.py`:
- Follow `Parameters` class pattern from [anomalyDetectionFeaturePlots.py](domains/anomaly-detection/anomalyDetectionFeaturePlots.py): `--report_directory`, `--verbose`, `--language` parameters
- Neo4j connection using `neo4j` Python driver (same pattern as anomaly detection)
- Load and execute Cypher `.cypher` files from `queries/` directory

**3.2** Data processing functions (extracted from notebooks):
- `group_to_others_below_threshold(data_frame, value_column, name_column, threshold)` → DataFrame  
- `filter_values_below_threshold(data_frame, value_column, upper_limit)` → DataFrame
- `explode_pie_slice(data_frame, index_value, base_value, emphasize_value)` → array
- `plot_pie_chart(data_frame, title, file_path)` → saves SVG with percentage labels, legend, "others" explode
- `plot_stacked_bar_chart(pivot_data, title, xlabel, ylabel, file_path)` → saves SVG
- `plot_scatter_with_annotations(data_frame, x, y, size, color, title, file_path, annotations)` → saves SVG

**3.3** Java chart generation (**22 charts**):
- 16 pie charts: top packages × {types, packages} × {overall, drill-down} × {full, second-level} + spread variants
- 2 stacked bar charts: external packages per artifact (full + second-level)
- 2 scatter plots: max/median internal package percentage vs external package count

**3.4** TypeScript chart generation (**~16 charts**):
- 16 pie charts: modules × {elements, modules} × {overall, drill-down} + namespace variants + spread

**3.5** `main()` function: parse arguments, connect Neo4j, generate charts per language, handle "no data" gracefully.

#### Phase 4: Python Entry Point Script (*parallel with Phase 3*)

**4.1** Create `externalDependenciesPython.sh`:
- Follow pattern of [anomalyDetectionPython.sh](domains/anomaly-detection/anomalyDetectionPython.sh)
- Set script directory, report directory
- Call `python externalDependencyCharts.py --language Java --report_directory ...`
- Call again with `--language Typescript`

#### Phase 5: Markdown Summary

**5.1** Create `summary/report.template.md`:
- YAML front matter (title, date, model version)
- Section 1: Executive Overview — total external packages/modules, key frameworks identified
- Section 2: Java External Dependencies — most used, spread analysis, per-artifact, aggregated (with `<!-- include:... -->` for tables and SVG references)
- Section 3: TypeScript External Dependencies — modules, namespaces, per-module breakdown, package.json
- Section 4: Architectural Recommendations — Hexagonal Architecture, Anti-Corruption Layer guidance
- Section 5: Glossary & Column Definitions — all column descriptions from notebook markdown

**5.2** Create `summary/externalDependenciesSummary.sh`:
- Follow [anomalyDetectionSummary.sh](domains/anomaly-detection/summary/anomalyDetectionSummary.sh) pattern
- Read CSV files → generate markdown table snippet includes
- Conditionally include SVG chart references if files exist
- Generate front matter (title, date, git tag)
- Assemble final `external_dependencies_report.md`

**5.3** Create `externalDependenciesMarkdown.sh`:
- Thin delegator to `summary/externalDependenciesSummary.sh` (matching [anomalyDetectionMarkdown.sh](domains/anomaly-detection/anomalyDetectionMarkdown.sh) pattern)

#### Phase 6: Exploration Notebooks

**6.1** Copy [jupyter/ExternalDependenciesJava.ipynb](jupyter/ExternalDependenciesJava.ipynb) → `explore/ExternalDependenciesJava.ipynb`, add `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` to metadata (matching [AnomalyDetectionExploration.ipynb](domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb)).

**6.2** Copy [jupyter/ExternalDependenciesTypescript.ipynb](jupyter/ExternalDependenciesTypescript.ipynb) → `explore/ExternalDependenciesTypescript.ipynb`, same metadata update.

---

### Relevant Files

**To create** (in `domains/external-dependencies/`):
- `README.md`, 3 entry point `.sh`, `externalDependencyCharts.py`, `summary/externalDependenciesSummary.sh`, `summary/report.template.md`

**To copy** (35 `.cypher` + 2 `.ipynb`):
- [cypher/External_Dependencies/](cypher/External_Dependencies/) → `queries/`
- [jupyter/ExternalDependenciesJava.ipynb](jupyter/ExternalDependenciesJava.ipynb), [jupyter/ExternalDependenciesTypescript.ipynb](jupyter/ExternalDependenciesTypescript.ipynb) → `explore/`

**Reference (read-only)**:
- [scripts/executeQueryFunctions.sh](scripts/executeQueryFunctions.sh) — `execute_cypher()`, `extractQueryParameter()`
- [scripts/cleanupAfterReportGeneration.sh](scripts/cleanupAfterReportGeneration.sh)
- [scripts/reports/ExternalDependenciesCsv.sh](scripts/reports/ExternalDependenciesCsv.sh) — query ordering reference
- [domains/anomaly-detection/anomalyDetectionFeaturePlots.py](domains/anomaly-detection/anomalyDetectionFeaturePlots.py) — `Parameters`, `get_file_path()`, Neo4j query pattern
- [domains/anomaly-detection/anomalyDetectionCsv.sh](domains/anomaly-detection/anomalyDetectionCsv.sh) — shell boilerplate
- [domains/anomaly-detection/summary/anomalyDetectionSummary.sh](domains/anomaly-detection/summary/anomalyDetectionSummary.sh) — template assembly, `<!-- include: -->` pattern

### Verification

1. **Structure**: Domain contains 3 `.sh` entry points, 1 `.py`, ~35 `.cypher` in queries/, 2 `.ipynb` in explore/, summary/ with `.sh` and `.md`
2. **Shell lint**: `shellcheck domains/external-dependencies/*.sh domains/external-dependencies/summary/*.sh`
3. **Python lint**: `python -m py_compile domains/external-dependencies/externalDependencyCharts.py`
4. **Pipeline discovery**: `find domains/ -name "*Csv.sh"`, `*Python.sh`, `*Markdown.sh` all return the new domain's scripts
5. **Notebook metadata**: Both explore/ notebooks contain `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
6. **Cypher count**: `ls domains/external-dependencies/queries/*.cypher | wc -l` matches original count
7. **No external changes**: No new files outside `domains/external-dependencies/`
8. **README completeness**: Documents prerequisites, entry points, folder structure

### Scope Boundaries

**Included**: All 35 cypher queries, ~38 SVG chart conversions, CSV entry point, Markdown summary, exploration notebooks, prerequisites documentation, package.json queries

**Excluded**: Graph visualizations (GraphViz), moving/deleting originals, reset queries, changes to central pipeline scripts, validation cypher query
