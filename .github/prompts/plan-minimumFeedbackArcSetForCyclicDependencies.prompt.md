# Plan: Implement Minimum Feedback Arc Set for Cyclic Dependencies

## Goal

Implement MFAS analysis for `domains/cyclic-dependencies`: top 5 SCCs of Java Packages and SCIP Modules, with CSV reports, adjacency matrix heatmaps, and GraphViz hierarchical DAG visualizations.

## Design Decisions (confirmed by user)

1. **SCC sharing**: Extract `runStronglyConnectedComponents` into `cyclicDependenciesSCC.sh`; both CSV and Python entry points source it.
2. **GraphViz**: Separate `cyclicDependenciesMfasVisualization.sh` shell script reading MFAS CSV outputs.
3. **Architectural patterns**: Structural-only (4 patterns from notebook: Directory Locality, Asymmetric Dependency, Hub Module, Balanced Coupling).

## Files to Create

### Shell Scripts

- `domains/cyclic-dependencies/cyclicDependenciesStronglyConnectedComponents.sh` — extracted Strongly Connected Component function
- `domains/cyclic-dependencies/cyclicDependenciesMinimumFeedbackArcSetPython.sh` — Python entry point
- `domains/cyclic-dependencies/cyclicDependenciesMinimumFeedbackArcSetVisualization.sh` — GraphViz entry point

### Python

- `domains/cyclic-dependencies/minimumFeedbackArcSet.py` — pure algorithm (no I/O)
- `domains/cyclic-dependencies/testMinimumFeedbackArcSet.py` — BDD unit tests
- `domains/cyclic-dependencies/minimumFeedbackArcSetCharts.py` — charts + CSV output

### Cypher Queries

- `domains/cyclic-dependencies/queries/Minimum_Feedback_Arc_Set_SCC_Edges.cypher`
- `domains/cyclic-dependencies/queries/Minimum_Feedback_Arc_Set_Java_Package_Detail_Edges.cypher`
- `domains/cyclic-dependencies/queries/Minimum_Feedback_Arc_Set_SCIP_Module_Detail_Edges.cypher`

## Files to Modify

- `domains/cyclic-dependencies/cyclicDependenciesCsv.sh` — remove `runStronglyConnectedComponents`, source `cyclicDependenciesSCC.sh`
- `domains/cyclic-dependencies/README.md` — document new MFAS feature

## Algorithm Structure (minimumFeedbackArcSet.py)

Based on Eades, Lin, Smyth (1993) + log-dampened weights + re-insertion pass:
```
find_feedback_arc_set(edges) → list[tuple]
  ├── build_dampened_graph(edges)
  ├── compute_greedy_ordering(nodes, out_adj, in_adj, out_weights, in_weights)
  ├── partition_edges(edges, ordering) → (dag_adj, candidates)
  └── minimize_arc_set(candidates, dag_adj)
```

## CSV Output Structure

Under `reports/cyclic-dependencies/{Java_Package,SCIP_Semantic_Index_Module}/`:
- `Minimum_Feedback_Arc_Set_Overview.csv` — SCC metadata + edge counts + pattern summary
- `Minimum_Feedback_Arc_Set_Edges.csv` — FAS edges with weights + pattern classification
- `Minimum_Feedback_Arc_Set_Detail_Edges.csv` — symbol/type detail edges per FAS arc

## SVG Output Structure

Under `reports/cyclic-dependencies/{Java_Package,SCIP_Semantic_Index_Module}/Graph_Visualizations/`:
- `JavaPackageMfasHeatmap<N>.svg` / `ScipModuleMfasHeatmap<N>.svg` — adjacency matrix (from Python)
- `JavaPackageMfas<N>.svg` / `ScipModuleMfas<N>.svg` — hierarchical DAG (from GraphViz)

## Verification

```bash
# Algorithm tests (no Neo4j needed)
python -m pytest domains/cyclic-dependencies/testMinimumFeedbackArcSet.py -v

# Shell linting
shellcheck domains/cyclic-dependencies/cyclicDependenciesStronglyConnectedComponents.sh
shellcheck domains/cyclic-dependencies/cyclicDependenciesMinimumFeedbackArcSetPython.sh
shellcheck domains/cyclic-dependencies/cyclicDependenciesMinimumFeedbackArcSetVisualization.sh