## Plan: Create `overview` Domain

Introduce a new self-contained `domains/overview/` domain by vertically slicing the existing overview reports. Copy (no deletion yet) all 15 Cypher queries, the CSV shell script basis, and all three Jupyter notebooks. Convert the notebook logic into a Python chart generator producing SVG and CSV outputs, copy the notebooks to `explore/` with the no-auto-execute marker, and assemble a markdown summary. Follows the `domains/node-embeddings/` pattern throughout.

**Decisions confirmed:**
- Output directory: `reports/overview/`
- `Overview_size_for_Typescript.cypher` added to `overviewCsv.sh` (not in original OverviewCsv.sh)
- `Node_labels_and_their_relationships.cypher` included in markdown summary with limit=30
- `Words_for_Wordcloud.cypher` copied into domain queries (not called by any script — for future use)
- `overviewCharts.py` reads from Neo4j via Python driver (matches notebook approach)

Ask before making any assumptions or decisions not explicitly covered in the instructions or the reference domain. Assure all questions are clarified before proceeding. Avoid abbreviations; write out all terms in full. 

---

### Phase 1 — Scaffolding and Cypher Queries

**1.1** Create all subdirectories: `domains/overview/`, `explore/`, `queries/overview/`, `summary/`

**1.2** Copy all 15 `.cypher` files from `cypher/Overview/` into `domains/overview/queries/overview/`

---

### Phase 2 — CSV Entry Point Script

**2.1** Create `domains/overview/overviewCsv.sh`:
- Shell conventions from `.github/instructions/shell-scripts.instructions.md`: `set -euo pipefail`, `IFS=$'\n\t'`, `CDPATH=. cd` script-dir resolution
- `OVERVIEW_QUERIES_DIR` resolved as `${OVERVIEW_SCRIPT_DIR}/queries/overview`
- Report name: `overview`, output to `${REPORTS_DIRECTORY}/overview/`
- Sources `../../scripts/executeQueryFunctions.sh` and `../../scripts/cleanupAfterReportGeneration.sh`
- Executes all 14 CSV queries (12 from original OverviewCsv.sh + `Overview_size_for_Typescript.cypher` → `Overview_size_for_Typescript.csv` + `Node_labels_and_their_relationships.cypher` → `Node_labels_and_their_relationships.csv`)
- `Node_labels_and_their_relationships.cypher` is executed and its CSV output is generated
- `usage()` function, `--help` and `--dry-run` flags
- Reference: `scripts/reports/OverviewCsv.sh` + `domains/node-embeddings/nodeEmbeddingsCsv.sh`

---

### Phase 3 — Explore Notebooks *(parallel with Phase 4)*

**3.1** Copy `jupyter/OverviewGeneral.ipynb` → `domains/overview/explore/OverviewGeneralExploration.ipynb`:
- Prepend "Exploration: " to title in the first Markdown cell
- Update all Cypher paths from `../cypher/Overview/` → `../queries/overview/`
- Add `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` to notebook `metadata` (pattern from `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb` line 2844)

**3.2–3.3** Same for `OverviewJavaExploration.ipynb` and `OverviewTypescriptExploration.ipynb`

---

### Phase 4 — Python Chart Generator *(parallel with Phase 3)*

**4.1** Create `domains/overview/overviewCharts.py` following `.github/instructions/python.instructions.md`:
- Non-interactive backend: `matplotlib.use('Agg')`
- `Parameters` dataclass: `report_directory`, `neo4j_uri`, `verbose`
- Neo4j connection via `neo4j.GraphDatabase.driver()` using `NEO4J_INITIAL_PASSWORD` env var
- Shared helpers (type-annotated, with docstrings):
  - `group_to_others_below_threshold()`, `explode_index_value()`, `plot_pie_chart()`, `plot_stacked_bar_chart()`
- `generate_general_charts()` → **5 SVG** + `Overview_General_Graph_Density.csv` (total nodes, total relationships, directed density)
- `generate_java_charts()` → **6 SVG** + `Java_Types_Per_Artifact_Grouped.csv`, `Java_Types_Per_Artifact_Grouped_Normalized.csv`; silently skips if no Java data
- `generate_typescript_charts()` → **5 SVG** + `Typescript_Elements_Per_Module_Grouped.csv`, `Typescript_Elements_Per_Module_Grouped_Normalized.csv`; silently skips if no TypeScript data
- Reference: `domains/node-embeddings/nodeEmbeddingsCharts.py`

**SVG files produced (16 total):**

| Category | Files |
|---|---|
| General (5) | `Overview_General_Node_Label_Combination_Count_High/Low.svg`, `Overview_General_Node_Label_Count.svg`, `Overview_General_Relationship_Type_Count_High/Low.svg` |
| Java (6) | `Overview_Java_Types_Per_Artifact_Stacked.svg`, `..._Class/Interface/Enum/Annotation_..._Normalized.svg`, `Overview_Java_Packages_Per_Artifact.svg` |
| TypeScript (5) | `Overview_Typescript_Elements_Per_Module_Stacked.svg`, `..._TypeAlias/Interface/Variable/Function_..._Normalized.svg` |

---

### Phase 5 — Python Entry Point *(depends on Phase 4)*

**5.1** Create `domains/overview/overviewPython.sh`:
- Checks for primary CSV marker; if absent, sources `overviewCsv.sh` first (self-contained)
- Calls `python "${OVERVIEW_SCRIPT_DIR}/overviewCharts.py" --report_directory ...`
- Reference: `domains/node-embeddings/nodeEmbeddingsPython.sh`

---

### Phase 6 — Markdown Summary *(depends on Phase 5)*

**6.1** Create `domains/overview/summary/report.template.md`:
- YAML front matter include, Table of Contents, three sections (General, Java, TypeScript)
- Each section: concise description, `<!-- include:... -->` directives for tables/charts, CSV download links
- `report_no_data.template.md` fallback

**6.2** Create `domains/overview/summary/overviewSummary.sh`:
- `overview_front_matter()`, `include_svgs_matching()`, `limit_markdown_table()`, `cypher_table()`, `csv_link()` helpers (matching `domains/node-embeddings/summary/nodeEmbeddingsSummary.sh`)
- `assemble_overview_report()`: writes per-section include files, then applies template to produce `overview_report.md`
- Executes `Node_labels_and_their_relationships.cypher` with limit=30 for the summary table

---

### Phase 7 — Markdown Entry Point *(depends on Phase 6)*

**7.1** Create `domains/overview/overviewMarkdown.sh`:
- Thin wrapper that delegates to `summary/overviewSummary.sh` (same pattern as `domains/node-embeddings/nodeEmbeddingsMarkdown.sh`)

---

### Phase 8 — Documentation

**8.1** `domains/overview/README.md` — purpose, entry points table, folder structure, execution order, outputs

**8.2** `domains/overview/PREREQUISITES.md`:
- Neo4j running with scanned code (Java or TypeScript)
- `NEO4J_INITIAL_PASSWORD` env var (needed by `overviewCharts.py`)
- `effectiveLineCount` and `cyclomaticComplexity` on `Method` nodes — provided by jQAssistant Java plugin scan (no separate enrichment step needed)
- No dependency on `cypher/Dependency_Enrichment/`, `cypher/Types/`, or `scripts/projectionFunctions.sh`

**8.3** `domains/overview/COPIED_FILES.md` — maps each original file to its domain path; serves as basis for the future cleanup step

---

### Relevant Files

- `scripts/reports/OverviewCsv.sh` — original CSV script
- `jupyter/OverviewGeneral.ipynb`, `OverviewJava.ipynb`, `OverviewTypescript.ipynb` — source notebooks
- `cypher/Overview/` — all 15 Cypher files to copy
- `domains/node-embeddings/` — full implementation reference
- `.github/instructions/shell-scripts.instructions.md`, `python.instructions.md`, `cypher-queries.instructions.md`

---

### Verification

1. `shellcheck` on all 4 shell scripts (overviewCsv.sh, overviewPython.sh, overviewMarkdown.sh, overviewSummary.sh)
2. Pylance type-check `overviewCharts.py`
3. Confirm `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` present in all 3 explore notebooks
4. `npx --yes markdown-link-check ... domains/overview/README.md` and `COPIED_FILES.md`
5. `analyze.sh --domain overview --report Csv --keep-running` → verify 13 CSV files in `reports/overview/`
6. `analyze.sh --domain overview --report Python --keep-running` → verify 16 SVG + 5 derived CSV files in `reports/overview/`
7. `analyze.sh --domain overview --report Markdown --keep-running` → verify `reports/overview/overview_report.md` is non-empty
