## Plan: SCC-Based Longest Path for SCIP Nodes

**TL;DR**: Move the SCC queries folder up one level so it's shared, refactor `topologicalSortBasedOnStronglyConnectedComponents` into 3 composable functions, add a new SCC-level longest path step for SCIP Module + Artifact nodes (replacing the broken `-cleaned` longest path), fix the visualization script's SCIP topology to SCC-based, and add new SCC-level GraphViz longest path queries that show clear dependency chains at component level.

---

**Steps**

### Phase 1 — Move SCC queries folder (prerequisite for all phases)
1. Move `queries/topological-sort/strongly-connected-components/` → `queries/strongly-connected-components/` (9 `.cypher` files, no content changes)

### Phase 2 — Update `internalDependenciesCsv.sh`
2. Add `SCC_CYPHER_DIR` variable pointing to `queries/strongly-connected-components` *(parallel with step 4a)*
3. Refactor `topologicalSortBasedOnStronglyConnectedComponents` into three composable functions:
   - `setupStronglyConnectedComponents` — SCC_Write → SCC_CreateNode → SCC_CreateDependency → delete_projection → SCC_TopologicalSort_Projection
   - `topologicalSortOnSCC` — SCC_TopologicalSort_Write → SCC_TopologicalSort_Propagate → Topological_Sort_Query → CSV
   - `topologicalSortBasedOnStronglyConnectedComponents` — unchanged wrapper calling both (backward-compatible for all non-SCIP node types)
4. Add new `longestPathOnSCC` function — calls new `SCC_Longest_paths_distribution_per_project.cypher` on `$dependencies_projection + '-components'`, writes CSV *(depends on step 5)*
5. SCIP path-finding section: replace `runPathFindingAlgorithms` with `allPairsShortestPath` only for `SemanticCodeIndexModule` and `SemanticCodeIndexArtifact`
6. SCIP topological sort section: for both Module + Artifact, replace the single `topologicalSortBasedOnStronglyConnectedComponents` call with the shared sequence: `setupStronglyConnectedComponents` → `topologicalSortOnSCC` → `longestPathOnSCC` *(depends on steps 3, 4)*

### Phase 3 — New Cypher queries *(can run parallel with Phase 2 steps)*
7. New file `queries/path-finding/SCC_Longest_paths_distribution_per_project.cypher`:
   - Streams `gds.dag.longestPath.stream($dependencies_projection + '-components')`
   - Source/target are `StronglyConnectedComponent` nodes (uses `.name`, `.size` properties)
   - Returns distribution (distance, pair counts, source/target counts, name examples)
   - Reuses `$dependencies_projection_node` param for `memberType` filtering
8. New file `queries/path-finding/SCC_Longest_paths_for_graphviz.cypher` (replaces `Path_Finding_6_Longest_paths_for_graphviz.cypher` for SCIP):
   - Streams `gds.dag.longestPath.stream($dependencies_projection + '-components')`
   - Node labels: strip `"Component "` prefix for single-node SCCs (show bare module name); for cycle SCCs (size > 1) show `"Cycle (N)\naround ModuleName"`; append level info `"\n(level L/maxL)"` using `topologicalSortMaxDistanceFromSource`
   - Edge labels: weight from `$dependencies_projection_weight_property` on SCC-level `DEPENDS_ON` relationships
   - Limit top 100 edges on longest paths (same as existing query)
9. New file `queries/path-finding/SCC_Longest_paths_contributors_for_graphviz.cypher` (replaces `Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher` for SCIP):
   - Same approach as step 8 but renders ALL dependencies between nodes that contribute to any of the top-50 longest paths
   - Highlights the single longest path in red, other contributors in dark orange (same coloring scheme as existing query)

### Phase 4 — Fix `graphs/internalDependenciesGraphs.sh`
10. Add `SCC_CYPHER_DIR` variable *(parallel with step 2)*
11. SCIP Artifact section: replace the 2-line `Topological_Sort_Exists/Write` pattern with inline SCC setup (same call sequence as `setupStronglyConnectedComponents` + `topologicalSortOnSCC`) using the existing `scip-artifact-path-finding` projection name; replace `Path_Finding_6_Longest_paths_for_graphviz.cypher` and `Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher` calls with the new SCC variants (steps 8, 9)
12. Add SCIP Module section (currently absent from visualization) — same pattern as SCIP Artifact *(depends on step 11)*

### Phase 5 — Documentation
13. Update `domains/internal-dependencies/README.md`:
    - Output directory structure: add `_longest_paths_distribution.csv` and `Graph_Visualizations/` entries under SCIP_Semantic_Index_Module and SCIP_Semantic_Index_Artifact
    - Add a note in "Path Finding" section explaining SCC-based longest path approach for SCIP nodes to handle cyclic dependencies
    - Mention that the `-components` projection is reused from topological sort for efficiency
14. Update `domains/internal-dependencies/PREREQUISITES.md` (if exists):
    - Clarify that the SCC approach handles cyclic dependencies in SCIP data (prerequisite capability)
    - Make the whole folder structure section concise, more high-level (no single files) while still retaining the What and Why (including Strongly Connected Components)
    - Avoid abbreviations like "SCC" in the prerequisites section; spell out "Strongly Connected Components" at least once.
    - Use US spelling like "analyze" instead of "analyse".
15. Add/update concise inline comments in Cypher queries:
    - `SCC_Longest_paths_distribution_per_project.cypher`: explain this operates on SCC component graph, not member nodes
    - `SCC_Longest_paths_for_graphviz.cypher`: explain node label format (cycle size annotation) and that level info comes from SCC-level topological sort
    - `SCC_Longest_paths_contributors_for_graphviz.cypher`: explain filtering for component-level dependencies contributing to longest paths
16. Add concise inline comments in shell script refactoring:
    - `setupStronglyConnectedComponents`: comment that this shared setup prepares the SCC graph structure and `-components` projection for reuse
    - `longestPathOnSCC`: comment that this reuses the existing `-components` projection created by topological sort (no recreation needed)

### Phase 6 — Tests
17. Existing shell script validation — update if needed:
    - Run `shellcheck domains/internal-dependencies/internalDependenciesCsv.sh` and `graphs/internalDependenciesGraphs.sh` *(step 2 of Verification already covers this)*
18. Integration test: create or update `scripts/testAnalyzeDomainOption.sh` (or similar test harness) to include a SCIP-indexed test project case:
    - Run `analyze.sh --domain internal-dependencies --report Csv --keep-running` on a SCIP-indexed project with known cycles
    - Assert: `SemanticCodeIndexModule_longest_paths_distribution.csv` and `SemanticCodeIndexArtifact_longest_paths_distribution.csv` exist and have non-empty rows
    - Assert: `SemanticCodeIndexModule_Topological_Sort.csv` exists unchanged
19. Regression test: ensure non-SCIP paths are unaffected:
    - Run full `analyze.sh --domain internal-dependencies` (default, all reports) on a Java-indexed project
    - Assert: Java Artifact, Package, TypeScript Module, NPM longest paths still generate using the existing `-cleaned` approach
    - Assert: topological sort for all non-SCIP types uses the old `Topological_Sort_Write.cypher` (not SCC-based) unchanged
20. Unit-like test: verify function composition:
    - Manually call `setupStronglyConnectedComponents`, then independently `topologicalSortOnSCC` and `longestPathOnSCC` with the same parameters
    - Assert: CSVs are produced in the expected order with consistent node counts
    - Assert: projections are cleaned up (deleted) as expected after each phase

---

**Relevant files**

- `domains/internal-dependencies/queries/topological-sort/strongly-connected-components/` — move all 9 files to `queries/strongly-connected-components/`
- `domains/internal-dependencies/internalDependenciesCsv.sh` — function refactoring + SCIP section changes; reference `topologicalSortBasedOnStronglyConnectedComponents` at lines ~230–260 for the function to split
- `domains/internal-dependencies/graphs/internalDependenciesGraphs.sh` — SCIP Artifact at lines ~200–225 (fix topology + swap GraphViz longest path queries to SCC variants); add SCIP Module block after it
- `domains/internal-dependencies/queries/path-finding/` — new `SCC_Longest_paths_distribution_per_project.cypher`, `SCC_Longest_paths_for_graphviz.cypher`, `SCC_Longest_paths_contributors_for_graphviz.cypher` alongside existing `Path_Finding_6_*`
- `domains/internal-dependencies/README.md` — output structure table, path finding section, SCC mention
- `domains/internal-dependencies/PREREQUISITES.md` — SCC prerequisite clarification (if file exists)

**Verification & Testing**

*Syntax & Static Checks (parallel with phases):*
1. `shellcheck domains/internal-dependencies/internalDependenciesCsv.sh` — verify refactored functions and new calls are shell-compliant
2. `shellcheck domains/internal-dependencies/graphs/internalDependenciesGraphs.sh` — verify SCIP sections and SCC setup inline code
3. Cypher syntax: run each new query file via `execute_cypher` in a test shell session to catch parse errors

*Integration & Regression Tests:*
4. **SCIP-only test** — Run `analyze.sh --domain internal-dependencies --report Csv --keep-running` on a SCIP-indexed project with known cycles:
   - Assert: `reports/internal-dependencies/SCIP_Semantic_Index_Module_longest_paths_distribution.csv` exists with non-zero row count
   - Assert: `reports/internal-dependencies/SCIP_Semantic_Index_Artifact_longest_paths_distribution.csv` exists with non-zero row count
   - Assert: `reports/internal-dependencies/SCIP_Semantic_Index_Module_Topological_Sort.csv` exists (unchanged, from topological sort phase)
   - Assert: No Neo4j errors in logs about DAG violations
5. **Visualization test** — Run `analyze.sh --domain internal-dependencies --report Visualization --keep-running` on the same SCIP project:
   - Assert: `reports/internal-dependencies/SCIP_Semantic_Index_Module/Graph_Visualizations/ScipModuleLongestPathsIsolated.svg` and `ScipModuleLongestPaths.svg` exist
   - Assert: `reports/internal-dependencies/SCIP_Semantic_Index_Artifact/Graph_Visualizations/ScipArtifactLongestPathsIsolated.svg` and `ScipArtifactLongestPaths.svg` exist
   - Assert: SVGs contain "Cycle" labels for cyclic components
   - Assert: No GraphViz syntax errors in logs
6. **Regression test** — Run full `analyze.sh --domain internal-dependencies` on a Java project (no SCIP):
   - Assert: Java Artifact, Package, TypeScript Module, NPM longest path CSVs exist using existing `-cleaned` queries
   - Assert: Non-SCC topological sort (old `Topological_Sort_Write.cypher`) is used for Java/TypeScript/NPM
   - Assert: All existing outputs match baseline (no unintended changes)
7. **Function composition test** (manual / mini-integration):
   - Source `internalDependenciesCsv.sh` in a test shell session
   - Call `setupStronglyConnectedComponents` with SCIP Module parameters
   - Call `topologicalSortOnSCC` on the same parameters — verify CSV is generated
   - Call `longestPathOnSCC` on the same parameters — verify CSV is generated
   - Assert: projections and SCC nodes are properly cleaned / transitioned between phases

---

**Decisions**
- Approach A chosen: longest path results at SCC component level (new distribution query on `-components` projection)
- SCIP only: Java Artifact, Package, TypeScript Module, NPM continue using existing `-cleaned` longest path and GraphViz queries unmodified
- Output filename unchanged for SCIP (`SemanticCodeIndexModule_longest_paths_distribution.csv`) — same name as before since it's a replacement, not addition
- The `-components` projection stays in GDS memory after topological sort; `longestPathOnSCC` reuses it immediately after without re-creating it; comment in code will explain that briefly.
- GraphViz node labels: strip `"Component "` prefix for readability; show cycle size inline (e.g. `"Cycle (3) around\n ModuleName"`) so users can immediately spot which nodes are part of a cycle and how large it is
