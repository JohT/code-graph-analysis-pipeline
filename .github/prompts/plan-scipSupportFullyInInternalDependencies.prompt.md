# Plan: Full SCIP Support in `domains/internal-dependencies`

**TL;DR**: Extend all report types — Python charts, GraphViz build levels, Markdown summary, report template, explore notebooks — to include SCIP Semantic Index nodes. New files for new behavior (OCP); existing files modified only for additive, low-risk changes. Module-level OO Design Metrics added for SCIP; Visibility Metrics skipped for SCIP.

---

## Phase 1 — New Cypher Queries *(all independent, parallel)*

1. Create `queries/internal-dependencies/List_all_SCIP_modules.cypher` — SCIP modules with in/out dependency counts and `isTest` flag
2. Create `queries/internal-dependencies/List_all_SCIP_artifacts.cypher` — SCIP artifacts with in/out dependency counts and `isExternal`
3. Create `queries/internal-dependencies/SCIP_SCC_Module_build_levels_for_graphviz.cypher` — SCC component nodes (`memberType = 'SemanticCodeIndexModule'`) with level coloring; edge weight = `referenceCount`; LIMIT 440; cycle labels (same pattern as `SCC_Longest_paths_for_graphviz.cypher`)
4. Create `queries/internal-dependencies/SCIP_SCC_Artifact_build_levels_for_graphviz.cypher` — same pattern for `SemanticCodeIndexArtifact`
5. Modify `queries/topological-sort/Topological_Sort_Critical_Path_Length.cypher` — add two `UNION ALL` blocks for `SemanticCodeIndexModule` and `SemanticCodeIndexArtifact`
6. Create `queries/object-oriented-design-metrics/Count_and_set_abstract_types_for_SCIP.cypher` — count abstract types (where `isAbstract=true`) per SCIP module
7. Create `queries/object-oriented-design-metrics/Calculate_and_set_Abstractness_for_SCIP.cypher` — calculate `abstractness = abstract_types / total_types` for each SCIP module
8. Create `queries/object-oriented-design-metrics/Set_Incoming_SCIP_Module_Dependencies.cypher` — count distinct types/modules from which this module receives incoming `DEPENDS_ON`
9. Create `queries/object-oriented-design-metrics/Set_Outgoing_SCIP_Module_Dependencies.cypher` — count distinct types/modules to which this module sends outgoing `DEPENDS_ON`
10. Create `queries/object-oriented-design-metrics/Calculate_and_set_Instability_for_SCIP.cypher` — calculate `instability = outgoing / (outgoing + incoming)` for each SCIP module
11. Create `queries/object-oriented-design-metrics/Calculate_distance_between_abstractness_and_instability_for_SCIP.cypher` — calculate distance to main sequence: `abs(abstractness + instability - 1)`

---

## Phase 2 — Python Chart Extensions *(parallel with Phase 1)*

### 2a. `pathFindingCharts.py` Extension
12. Add `SCIP_ABSTRACTION_LEVELS` constant (two entries: Module + Artifact). Add `generate_scip_charts_for_level()` — same chart types as `generate_charts_for_level()` but reads `_StronglyConnectedComponents_longest_paths_distribution.csv` for the longest path charts. Call from `main()` after the existing loop. Existing `ABSTRACTION_LEVELS` and `generate_charts_for_level()` **untouched**.

### 2b. `objectOrientedDesignMetricsCharts.py` Extension
13. Add `SCIP_ABSTRACTION_LEVELS` constant (one entry: Module). Add `generate_scip_oo_design_metrics_charts()` — generates Main Sequence scatter plot (`Abstractness_vs_Instability.svg`) and distance distribution chart for SCIP modules using the new CSV files created by queries in Phase 1 items 6–11. Call from `main()` after the existing Java/TypeScript blocks. Existing code **untouched**.

---

## Phase 3 — Shell Script Extensions *(depends on Phase 1 queries 3+4)*

14. Modify `graphs/internalDependenciesGraphs.sh` — add SCIP SCC build levels blocks for Module and Artifact; reuse the existing `setupStronglyConnectedComponentsForSccVisualization()` helper already defined in the file
15. Modify `internalDependenciesCsv.sh` — add the **missing** `cleanupAfterReportGeneration.sh` call for `SCIP_Semantic_Index_Type` (currently absent from cleanup)

---

## Phase 4 — Markdown Summary + Report Template *(depends on Phases 1–3)*

16. Modify `summary/internalDependenciesSummary.sh`:
   - SCIP internal structure: `execute_limited_table` for both new list queries + new listing for Internal Types
   - SCIP APSP tables: `projectionExists "dependencies_projection=scip-module-path-finding"` guard + `Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher`; same for Artifact
   - SCIP SCC longest path: CSV-only links (no live query — avoids dependency on ephemeral `-components` projection)
   - SCIP OO Design Metrics: Execute the new queries for abstractness/instability/distance; generate CSV tables
   - SVG chart references for SCIP Module + Artifact (all-pairs + SCC longest path + OO Design Metrics charts)
   - Graph visualization SVG references: `ScipModuleBuildLevels.svg`, `ScipArtifactBuildLevels.svg`, existing longest path SVGs

17. Modify `summary/report.template.md` — add four new top-level sections:
    - **Section 3.4 SCIP Semantic Index Structure** (list modules, artifacts, internal types; `empty.md` fallback)
    - **Section 4.4 SCIP Semantic Index Path Finding** (APSP + SCC longest path; `empty.md` fallback)
    - **Section 6.4 SCIP Semantic Index Graphs** (build levels + longest path SVGs; `empty.md` fallback)
    - **Section 8.4 SCIP Semantic Index OO Design Metrics** (main sequence scatter + distance tables + chart SVGs; `empty.md` fallback)

---

## Phase 5 — Explore Notebooks *(parallel with Phases 2–4)*

18. Create `explore/InternalDependenciesScip.ipynb` — mirrors `InternalDependenciesJava.ipynb`; uses the new `List_all_SCIP_modules.cypher` and `List_all_SCIP_artifacts.cypher`; tables sorted by various dependency metrics
19. Create `explore/PathFindingScip.ipynb` — mirrors `PathFindingTypescript.ipynb`; APSP via `create_directed_unweighted_projection`; SCC longest path via explicit SCC setup + `SCC_Longest_paths_distribution_per_project.cypher`; clearly documents the cycle-handling SCC approach
20. Create `explore/ObjectOrientedDesignMetricsScip.ipynb` — mirrors `ObjectOrientedDesignMetricsJava.ipynb` and `ObjectOrientedDesignMetricsTypescript.ipynb`; displays Main Sequence scatter plot for SCIP modules; shows instability, abstractness, and distance metrics; allows filtering and exploration by module properties

---

## Phase 6 — Documentation

21. Update [domains/internal-dependencies/README.md](domains/internal-dependencies/README.md) — output listing, SVG charts description, Markdown summary section mentions, OO Design Metrics section

---

## Relevant Files

| Type | File |
|------|------|
| New | `queries/internal-dependencies/List_all_SCIP_modules.cypher` |
| New | `queries/internal-dependencies/List_all_SCIP_artifacts.cypher` |
| New | `queries/internal-dependencies/SCIP_SCC_Module_build_levels_for_graphviz.cypher` |
| New | `queries/internal-dependencies/SCIP_SCC_Artifact_build_levels_for_graphviz.cypher` |
| New | `queries/object-oriented-design-metrics/Count_and_set_abstract_types_for_SCIP.cypher` |
| New | `queries/object-oriented-design-metrics/Calculate_and_set_Abstractness_for_SCIP.cypher` |
| New | `queries/object-oriented-design-metrics/Set_Incoming_SCIP_Module_Dependencies.cypher` |
| New | `queries/object-oriented-design-metrics/Set_Outgoing_SCIP_Module_Dependencies.cypher` |
| New | `queries/object-oriented-design-metrics/Calculate_and_set_Instability_for_SCIP.cypher` |
| New | `queries/object-oriented-design-metrics/Calculate_distance_between_abstractness_and_instability_for_SCIP.cypher` |
| New | `explore/InternalDependenciesScip.ipynb` |
| New | `explore/PathFindingScip.ipynb` |
| New | `explore/ObjectOrientedDesignMetricsScip.ipynb` |
| Modify | `pathFindingCharts.py` |
| Modify | `objectOrientedDesignMetricsCharts.py` |
| Modify | `graphs/internalDependenciesGraphs.sh` |
| Modify | `internalDependenciesCsv.sh` |
| Modify | `summary/internalDependenciesSummary.sh` |
| Modify | `summary/report.template.md` |
| Modify | `queries/topological-sort/Topological_Sort_Critical_Path_Length.cypher` |
| Modify | `README.md` |

---

## Verification

Against `temp/react-router-17.13.2-scip-without-jqassistant` with `NEO4J_INITIAL_PASSWORD=neo4jinitial`:

1. `analyze.sh --domain internal-dependencies --report Csv --keep-running` — SCIP CSVs present, no SCIP_Semantic_Index_Type directory left behind; OO Design Metrics CSVs present (`*_Abstractness*.csv`, `*_Instability*.csv`, `*_distance*.csv`)
2. `analyze.sh --domain internal-dependencies --report Python --keep-running` — SCIP SVG charts generated in `SCIP_Semantic_Index_Module/` and `SCIP_Semantic_Index_Artifact/`; OO Design Metrics charts present (Main Sequence scatter plots, distance distributions)
3. `analyze.sh --domain internal-dependencies --report Visualization --keep-running` — `ScipModuleBuildLevels.svg` and `ScipArtifactBuildLevels.svg` present
4. `analyze.sh --domain internal-dependencies --report Markdown --keep-running` — sections 3.4, 4.4, 6.4, 8.4 appear in `internal_dependencies_report.md`
5. `shellcheck` on all modified shell scripts
6. Open and run `PathFindingScip.ipynb`, `InternalDependenciesScip.ipynb`, and `ObjectOrientedDesignMetricsScip.ipynb` against running Neo4j

---

## Decisions

- **OO Design Metrics for SCIP**: **Implemented at Module scope** — modules are treated like Java packages, containing internal types some of which are abstract. Abstractness calculated as `(abstract_types_in_module) / (total_types_in_module)`. Instability calculated as `(outgoing_module_dependencies) / (incoming + outgoing_module_dependencies)`. Visibility Metrics skipped (less meaningful for SCIP modules).
- **Longest path CSV for SCIP charts**: **`_StronglyConnectedComponents_longest_paths_distribution.csv`**
- **Build levels visualization**: **SCC component graph** (consistent with existing SCIP longest-path viz)
- **SCIP placement in report**: **new top-level sections** (3.4, 4.4, 6.4, 8.4)
- **Missing SCIP data**: **silently omit** (`empty.md` fallback)
- **SCC longest path in Markdown table**: **CSV link only** (projection ephemeral)
- **SCIP Internal Types**: Listed in section 3.4.3 with separate subsection; topological sort CSV provided; no visualization (too large/messy)

---

## Open Questions for Refinement

**Q1: Notebook complexity trade-off**
> The `PathFindingScip.ipynb` will be notably more complex than `PathFindingTypescript.ipynb` because it needs to set up SCC components manually before running the longest path. Are you OK with that complexity in the notebook, or should the notebook defer to pre-computed CSV files (like the Python charts do)?
**A1: Ok with the additional complexity**. Split it up into granular well named and documented functions.

**Q2: Error handling in Python charts**
> When `_StronglyConnectedComponents_longest_paths_distribution.csv` is missing (e.g., no SCIP data at all), should the SCIP chart generation fail explicitly or silently skip? Current design: silently skip (consistent with missing Java/TS CSVs).
**A2: Silent skip on missing data, otherwise fail fast**. If there are no SCIP nodes, then silently skip. If there should have been a file, consider running the csv generation or fail fast. In doubt, failing is better than hiding.

**Q3: SCIP Type nodes in internal structure section**
> Should SCIP Internal Types appear in a separate subsection (e.g., 3.4.3 SCIP Internal Types) with a listing query, or is topological sort + SCC longest path enough coverage?
**A3: Yes, SCIP Internal Types should appear in a separate subsection**

**Q4: Build levels for SCIP Type nodes**
> SCIP Internal Types also have topological sort results (CSV already generated). Should we add `ScipModuleBuildLevels.svg` visualization for Type nodes (similar to Java Type but uncommented)? Current design: only Module and Artifact SCC visualizations; Type handling via CSV only.
**A4: No Visualization of Types nodes**: They could get large, messy and confusing. Write a short hint why they are skipped and link the topological sort results

**Q5: Module-level OO Design Metrics**
> With the new `isAbstract` property on SCIP Internal Type nodes, should we implement OO Design Metrics (abstractness/instability/distance-to-main-sequence) at the SCIP Module scope?
**A5: YES, implement at Module scope**: Treat SCIP modules like Java packages. Calculate module-level abstractness from contained abstract types, instability from inter-module dependencies. This enables Main Sequence analysis and visualization for SCIP modules, completing the parity with Java/TypeScript OO metrics.
---

## Implementation Order Recommendation

1. **Start Phase 1** (Cypher queries 1–11) — parallel, foundational
   - Items 1–5 (path finding, visualization queries) independent
   - Items 6–11 (OO metrics queries) independent of 1–5 but depend on same SCIP Type/Module structure
2. **Then Phase 2** (pathFindingCharts.py + objectOrientedDesignMetricsCharts.py extensions) — depends on Phase 1 CSVs
3. **Then Phase 3** (shell scripts) — depends on Phase 1 queries 3–4
4. **Then Phase 4** (Markdown + report template) — depends on Phases 1–3 CSVs and images
5. **Parallel: Phase 5** (notebooks) — mirrors existing patterns; low dependency risk
6. **Final: Phase 6** (README update) — after all else
