# Plan: SCIP Support for cyclic-dependencies Domain

**TL;DR**: Add 4 new Cypher queries, 1 exploration notebook, 1 fallback template, and extend 4 existing files with SCIP-specific blocks. Module cycles use type-level traversal (`SemanticCodeIndexInternalType`) — same pattern as the Java package queries — enabling identical graph visualization support. Artifact cycles use a single overview query.

---

## Phase 1: New Cypher Queries *(4 files — parallel with phases 2+3)*

1. `domains/cyclic-dependencies/queries/Cyclic_Dependencies_for_SCIP_Module.cypher` — Module overview. Based on [queries/Cyclic_Dependencies.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies.cypher): substitute `Package`→`SemanticCodeIndexModule`, `Type`→`SemanticCodeIndexInternalType`, use `display_name` for type names, `module.projectName` instead of an artifact lookup, deduplication via `(forward > backward OR (equal AND module.fqn >= dependentModule.fqn))`. Returns `projectName, moduleName, dependentProjectName, dependentModuleName, forwardToBackwardBalance, numberForward, numberBackward, someForwardDependencies[0..9], backwardDependencies`.

2. `domains/cyclic-dependencies/queries/Cyclic_Dependencies_Breakdown_for_SCIP_Module.cypher` — Module breakdown. Based on [queries/Cyclic_Dependencies_Breakdown.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies_Breakdown.cypher): UNWIND both directions. **Column order is critical** for visualization awk compatibility: `projectName($2-quoted), moduleName($4-quoted), dependentProjectName($6-quoted), dependentModuleName($8-quoted), dependency($10-quoted), forwardToBackwardBalance, numberForward, numberBackward`.

3. `domains/cyclic-dependencies/queries/Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.cypher` — Same as #2, `UNWIND backwardDependencies` only. Based on [queries/Cyclic_Dependencies_Breakdown_Backward_Only.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies_Breakdown_Backward_Only.cypher).

4. `domains/cyclic-dependencies/queries/Cyclic_Dependencies_between_SCIP_Artifacts_as_unwinded_List.cypher` — Artifact overview. Based on [queries/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher). ⚠️ **Before writing**: check `domains/scip-index-import/` for whether `SemanticCodeIndexArtifact -[:CONTAINS]-> SemanticCodeIndexModule` exists. If yes: traverse artifact→module for module-pair detail. If no: use direct artifact `DEPENDS_ON` edges with `referenceCount`.

---

## Phase 2: Exploration Notebook *(1 file — parallel with phases 1+3)*

5. `domains/cyclic-dependencies/explore/CyclicDependenciesScipExploration.ipynb` — Based on [explore/CyclicDependenciesJavaExploration.ipynb](domains/cyclic-dependencies/explore/CyclicDependenciesJavaExploration.ipynb). Two sections:
   - Section 1 (SCIP Module): Tables 1a (overview, limit 40), 1b (breakdown, limit 40), 1c (backward only, limit 40)
   - Section 2 (SCIP Artifact): Table 2a (artifact overview, limit 40)

---

## Phase 3: Fallback Template *(1 file — parallel with phases 1+2)*

6. `domains/cyclic-dependencies/summary/report_no_scip_data.template.md` — Content: `⚠️ _No data available — no SCIP Semantic Index data detected._` Pattern from [summary/report_no_typescript_data.template.md](domains/cyclic-dependencies/summary/report_no_typescript_data.template.md).

---

## Phase 4: Shell Script Additions *(depends on Phase 1)*

7. [cyclicDependenciesCsv.sh](domains/cyclic-dependencies/cyclicDependenciesCsv.sh) — Add SCIP block after the TypeScript section: create `SCIP_Semantic_Index_Module/` and `SCIP_Semantic_Index_Artifact/` dirs, execute 3 module queries + 1 artifact query, call `cleanupAfterReportGeneration.sh` on both new dirs.

8. [cyclicDependenciesVisualization.sh](domains/cyclic-dependencies/cyclicDependenciesVisualization.sh) — Add one `process_language_cycle_graphs` call after the TypeScript block:
   ```
   source CSV:    SCIP_Semantic_Index_Module/Cyclic_Dependencies_for_SCIP_Module.csv
   breakdown CSV: SCIP_Semantic_Index_Module/Cyclic_Dependencies_Breakdown_for_SCIP_Module.csv
   output dir:    SCIP_Semantic_Index_Module/Graph_Visualizations/
   SVG prefix:    ScipModuleCyclicDependencies
   relative dir:  SCIP_Semantic_Index_Module/Graph_Visualizations
   label:         SCIP Semantic Index Module
   ```

---

## Phase 5: Summary + Report Template Additions *(depends on Phases 1+3)*

9. [summary/cyclicDependenciesSummary.sh](domains/cyclic-dependencies/summary/cyclicDependenciesSummary.sh) — Add 4 `execute_limited_table` calls (3 module, 1 artifact), copy `report_no_scip_data.template.md` fallback, copy `SCIP_Semantic_Index_Module/Graph_Visualizations/GraphVisualizationsReferenceForSummary.md` → `GraphVisualizationsScipModuleReference.md`.

10. [summary/report.template.md](domains/cyclic-dependencies/summary/report.template.md) — Add TOC entry + new **section 4: SCIP Semantic Index Cyclic Dependencies** with subsections 4.1 (Module Overview), 4.2 (Module Breakdown), 4.3 (Module Backward Only), 4.4 (Artifact), 4.5 (Module Graph Visualizations). Update Glossary with "SCIP module" and "SCIP artifact".

---

## Phase 6: README Update *(depends on all above)*

11. [domains/cyclic-dependencies/README.md](domains/cyclic-dependencies/README.md) — Add SCIP to overview, output folder structure (`SCIP_Semantic_Index_Module/`, `SCIP_Semantic_Index_Artifact/`), and prerequisites (SCIP index must be imported first via `scip-index-import` domain).

---

## Relevant files

| File | Role |
|------|------|
| [queries/Cyclic_Dependencies.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies.cypher) | Template for SCIP module overview query |
| [queries/Cyclic_Dependencies_Breakdown.cypher](domains/cyclic-dependencies/queries/Cyclic_Dependencies_Breakdown.cypher) | Template for SCIP module breakdown — authoritative for CSV column positions |
| [cyclicDependenciesVisualization.sh](domains/cyclic-dependencies/cyclicDependenciesVisualization.sh) `process_language_cycle_graphs()` | Reused as-is — reads $4/$8/$10 from breakdown CSV |
| [domains/internal-dependencies/queries/internal-dependencies/List_all_SCIP_modules.cypher](domains/internal-dependencies/queries/internal-dependencies/List_all_SCIP_modules.cypher) | Reference for `SemanticCodeIndexModule` property names |
| `domains/scip-index-import/` | Check for `Artifact -[:CONTAINS]-> Module` before writing Query #4 |

---

## Verification

1. `shellcheck` on `cyclicDependenciesCsv.sh`, `cyclicDependenciesVisualization.sh`, `cyclicDependenciesSummary.sh` after changes
2. `npx --yes markdown-link-check ... README.md` after README update
3. `analyze.sh --domain cyclic-dependencies --report Csv --keep-running` against a SCIP workspace
4. `analyze.sh --domain cyclic-dependencies --report Visualization --keep-running`
5. `analyze.sh --domain cyclic-dependencies --report Markdown --keep-running`

---

## Further Consideration

The SCIP artifact query (#4) has a design branch depending on the graph schema in `domains/scip-index-import/`. The implementer should read that domain first to choose the traversal approach.
