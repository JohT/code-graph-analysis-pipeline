# Plan: SCIP Overview Support in domains/overview

Add SCIP index nodes to the overview domain: exploration notebook, Cypher queries, CSV output, SVG charts, and a Markdown summary section. Full pipeline, new files only, no changes to Java or TypeScript logic.

## Steps

### Phase 1: Cypher Queries (2 new files in `domains/overview/queries/overview/`)

1. `Overview_size_for_Scip.cypher` — count total nodes, relationships, artifacts, modules, internal types, external types, total reference count from `DEPENDS_ON` edges
2. `Number_of_types_per_project_for_Scip.cypher` — count internal types grouped by `a.projectName`, `t.language`; return `projectName`, `language`, `numberOfTypes`; ordered by `numberOfTypes DESC`

### Phase 2: Exploration Notebook

3. Create `domains/overview/explore/OverviewScipExploration.ipynb`
   - Pattern: [ExternalDependenciesScip.ipynb](domains/external-dependencies/explore/ExternalDependenciesScip.ipynb) (typed helpers, `cast`/`LiteralString`)
   - Section 1: SCIP size table (Q1)
   - Section 2: Types per project table (Q2 raw + pivot by language)
   - Section 2 chart: stacked bar, top 30 projects

### Phase 3: CSV output

4. Extend `domains/overview/overviewCsv.sh` with two `execute_cypher` calls producing `Overview_size_for_Scip.csv` and `Number_of_types_per_project_for_Scip.csv`

### Phase 4: SVG Charts

5. Extend `domains/overview/overviewCharts.py`: add `generate_scip_charts()` function (called from `main`, guarded by empty-data check)
   - `Overview_Scip_Types_Per_Project_Stacked.svg` — stacked bar, top 30 projects, columns = languages
   - `Overview_Scip_{Language}_Types_Per_Project_Normalized.svg` — normalized bar per language (only when language has more than 1 project)
   - `Scip_Types_Per_Project_Grouped.csv` and `Scip_Types_Per_Project_Grouped_Normalized.csv` as side outputs
   - Mirror pattern of existing `generate_java_charts()` in [overviewCharts.py](domains/overview/overviewCharts.py)

### Phase 5: Markdown Summary

6. Extend `domains/overview/summary/overviewSummary.sh`: add SCIP include blocks after TypeScript section
   - `cypher_table` for `Overview_size_for_Scip.cypher` → `ScipOverviewSize.md`
   - `include_svgs_matching "Overview_Scip_*.svg"` → `OverviewScipCharts.md`
7. Extend `domains/overview/summary/report.template.md`: add SCIP section after TypeScript section using the new includes

## Relevant files

- `domains/overview/queries/overview/` — 2 new `.cypher` files
- `domains/overview/explore/OverviewScipExploration.ipynb` — new notebook
- `domains/overview/overviewCsv.sh` — add 2 CSV execute calls
- `domains/overview/overviewCharts.py` — add `generate_scip_charts()`
- `domains/overview/summary/overviewSummary.sh` — add SCIP include blocks
- `domains/overview/summary/report.template.md` — add SCIP section

## Verification

1. `shellcheck domains/overview/overviewCsv.sh domains/overview/summary/overviewSummary.sh`
2. Pylance type check `overviewCharts.py` (no new errors)
3. `analyze.sh --domain overview --report Csv --keep-running` — completes without error
4. `analyze.sh --domain overview --report Python --keep-running` — SCIP SVGs generated when SCIP data present; graceful skip otherwise
5. `analyze.sh --domain overview --report Markdown --keep-running` — report assembles; SCIP section present or gracefully empty via `cleanupAfterReportGeneration.sh`
6. Open `OverviewScipExploration.ipynb` and run all cells against a SCIP-loaded Neo4j database

## Decisions

- No cyclomatic complexity; no effective lines of code (SCIP has no methods with these properties)
- Types grouped by `projectName` + `language` (not by SCIP label, since language is nearly always uniform per project)
- All new logic in new files or appended functions; zero changes to existing Java/TypeScript code paths
- Summary SCIP section is optional: `cleanupAfterReportGeneration.sh` removes empty includes automatically

## SCIP Graph Model

- Internal types: `(t:SemanticCodeIndexInternalType)`
- External types: `(e:SemanticCodeIndexExternalType)`
- Modules: `(m:SemanticCodeIndexModule)-[:CONTAINS]->(t)`
- Artifacts: `(a:SemanticCodeIndexArtifact)-[:CONTAINS]->(m)`
- Dependency edge: `(t)-[:DEPENDS_ON {referenceCount:N}]->(e)`
- `a.projectName` groups by project; `t.language` per type
