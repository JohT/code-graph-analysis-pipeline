# Plan: SCIP Support for Anomaly Detection Domain

## TL;DR
Extend `domains/anomaly-detection` to classify and visualize SCIP-indexed code at three levels: `SemanticCodeIndexInternalType`, `SemanticCodeIndexModule`, `SemanticCodeIndexArtifact`. All core GDS feature algorithms (betweenness, page rank, article rank, clustering, connected components) are parameterized by `$projection_node_label` and work as-is. The Python ML pipeline scripts (tunedLeidenCommunityDetection, tunedNodeEmbeddingClustering, etc.) are also node-type agnostic. Work needed: 3 new abstractness Cypher queries + additive SCIP blocks in 4 shell scripts + 1 new SCIP treemap Python script + 1 explore notebook + Python unit tests + README update.

**Key properties used**: weight = `referenceCount` (DEPENDS_ON edge), identification = `fqn` (node property), abstractness = `isAbstract` boolean on `SemanticCodeIndexInternalType`. File paths only on `SemanticCodeIndexInternalType.file` (InternalType level only → treemap applies to InternalType only).

**Threshold**: `is_sufficient_data_available` (15-node minimum) in `anomalyDetectionPython.sh` already wraps all level invocations — applies automatically to all 3 SCIP levels including Artifact.

### Design decisions (resolved during implementation)

| Question | Decision |
|----------|----------|
| Treemap file prefix | Use `projection_language=SCIP` parameter → `SCIPTreemap1...svg` (consistent with `scipTreemapVisualizations.py` in archetypes domain) |
| Treemap query scope | Only anomalous nodes — match existing Java/TS `treemapVisualizations.py` behavior. Filter by `anomalyScore < threshold OR anomalyBridgeRank IS NOT NULL OR anomalyOutlierRank IS NOT NULL`. |
| Notebook | Full notebook with real Cypher queries, independent from specific dataset. No `code_graph_analysis_pipeline_data_validation` metadata (this key has been removed from all notebooks). |

---

## Phase 1 — Abstractness feature queries (3 new files, independent)

New files in `domains/anomaly-detection/features/`:

### 1a. `AnomalyDetectionFeature_Abstractness_ScipInternalType.cypher`
- Reference: `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipInternalType.cypher`
- MATCH `SemanticCodeIndexInternalType`, use `isAbstract` boolean → 1.0 or 0.0
- SET `n.abstractness`, return bin distribution

### 1b. `AnomalyDetectionFeature_Abstractness_ScipModule.cypher`
- Reference: `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipModule.cypher`
- MATCH `SemanticCodeIndexModule`, aggregate `isAbstract` across CONTAINS → SemanticCodeIndexInternalType
- SET `m.abstractness`, return bin distribution

### 1c. `AnomalyDetectionFeature_Abstractness_ScipArtifact.cypher`
- Reference: `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipArtifact.cypher`
- MATCH `SemanticCodeIndexArtifact`, aggregate via direct CONTAINS link
- SET `a.abstractness`, return bin distribution

Then in `anomaly_detection_features()` in both `anomalyDetectionCsv.sh` and `anomalyDetectionPython.sh`: add 3 calls after the TypeScript abstractness call:
```
execute_cypher_queries_until_results "...AnomalyDetectionFeature-Abstractness-Exists.cypher"
                                     "...AnomalyDetectionFeature_Abstractness_ScipInternalType.cypher" "${@}"
execute_cypher_queries_until_results "...Exists.cypher" "...ScipModule.cypher" "${@}"
execute_cypher_queries_until_results "...Exists.cypher" "...ScipArtifact.cypher" "${@}"
```

---

## Phase 2 — CSV pipeline: `anomalyDetectionCsv.sh` (depends on Phase 1)

After the TypeScript block, add 3 SCIP blocks (same pattern as Java Artifact — no `is_sufficient_data_available` guard in CSV pipeline):

- `scip-type-anomaly-detection` / `SemanticCodeIndexInternalType` / `referenceCount` / `SCIP`
- `scip-module-anomaly-detection` / `SemanticCodeIndexModule` / `referenceCount` / `SCIP`
- `scip-artifact-anomaly-detection` / `SemanticCodeIndexArtifact` / `referenceCount` / `SCIP`

Each: `createUndirectedDependencyProjection` → `createDirectedDependencyProjection` → `anomaly_detection_csv_reports`

---

## Phase 3 — Python ML pipeline: `anomalyDetectionPython.sh` (depends on Phase 1)

After the TypeScript block, add 3 SCIP blocks each with `is_sufficient_data_available` guard:

**InternalType block** (also calls treemap):
```
is_sufficient_data_available SemanticCodeIndexInternalType + referenceCount
  createUndirectedDependencyProjection scip-type-anomaly-detection ...
    createDirectedDependencyProjection scip-type-anomaly-detection-directed ...
    anomaly_detection_python_reports ... SCIP ...
    anomaly_detection_scip_treemap_charts (new function, calls scipTreemapAnomalyDetection.py)
```

**Module block**: same pattern, no treemap call

**Artifact block**: same pattern, no treemap call

New function `anomaly_detection_scip_treemap_charts()` added to `anomalyDetectionPython.sh` — calls `scipTreemapAnomalyDetection.py` with `--report_directory`.

---

## Phase 4 — SCIP treemap Python script: `scipTreemapAnomalyDetection.py` (new file, depends on Phase 3)

**File**: `domains/anomaly-detection/scipTreemapAnomalyDetection.py`

- Reference: `domains/archetypes/scipTreemapVisualizations.py` (structure, path-building helpers)
- `Parameters` class: `required_parameters_ = ["projection_language"]` — uses `projection_language=SCIP` as the SVG file name prefix (`SCIPTreemap1...svg`)
- **Query scope**: anomalous nodes only — `SemanticCodeIndexInternalType` nodes where `anomalyScore < threshold OR anomalyBridgeRank IS NOT NULL OR anomalyOutlierRank IS NOT NULL` (same filter as `treemapVisualizations.py`)
- Connects anomalous type to its artifact via `OPTIONAL MATCH (artifact:SemanticCodeIndexArtifact)-[:CONTAINS]->(anomalous)` for the `projectName` prefix
- Wraps chart generation in a testable `generate_treemap_visualizations(data, parameters, driver)` function
- Generates 4 SVG files with `projection_language` prefix:
  - `{prefix}Treemap1AverageAnomalyScorePerDirectory.svg`
  - `{prefix}Treemap2ArchetypesOverviewPerDirectory.svg`
  - `{prefix}Treemap3ArchetypeBridgePerDirectory.svg`
  - `{prefix}Treemap4ArchetypeOutlierPerDirectory.svg`

---

## Phase 5 — Graph visualizations: `anomalyDetectionGraphs.sh` (parallel with Phase 2)

After the TypeScript block, add 3 SCIP calls:
```
anomaly_detection_graph_visualization SCIP SemanticCodeIndexInternalType referenceCount
anomaly_detection_graph_visualization SCIP SemanticCodeIndexModule        referenceCount
anomaly_detection_graph_visualization SCIP SemanticCodeIndexArtifact      referenceCount
```

No changes to `TopBridge.cypher`, `TopOutlier.cypher`, or `TopCentral.template.gv` — all use `$projection_node_label`, `$projection_weight_property`, `anomalyBridgeRank`/`anomalyOutlierRank`, `fqn`. SCIP nodes have all these.

---

## Phase 6 — Summary: `anomalyDetectionSummary.sh` (parallel with Phase 2)

After the TypeScript `anomaly_detection_report` call, add 3:
```
anomaly_detection_report SemanticCodeIndexInternalType SCIP
anomaly_detection_report SemanticCodeIndexModule        SCIP
anomaly_detection_report SemanticCodeIndexArtifact      SCIP
```

No changes to summary Cypher queries — all use `$projection_node_label`. `anomaly_detection_deep_dive_report()` already skips if detail directory is empty. `AnomaliesPerAbstractionLayer.cypher` aggregates all anomaly labels — SCIP nodes appear naturally.

---

## Phase 7 — Explore notebook: `AnomalyDetectionScipExploration.ipynb` (independent)

**File**: `domains/anomaly-detection/explore/AnomalyDetectionScipExploration.ipynb`

**Note**: `code_graph_analysis_pipeline_data_validation` metadata key has been removed from all notebooks and must NOT be added to new ones.

Structure (following `AnomalyDetectionIsolationForestExploration.ipynb` pattern):
1. Setup: imports, Neo4j connection, helper functions
2. SCIP InternalType: node count, features overview, anomaly score distribution
3. SCIP InternalType: top Bridge nodes, top Outlier nodes
4. SCIP Module: node count, anomaly overview
5. SCIP Artifact: node count, anomaly overview (if data available)

Queries inline using `SemanticCodeIndexInternalType` label. Uses `fqn` and `file` for node identification.

---

## Phase 8 — Python unit tests (depends on Phase 4)

**File**: `domains/anomaly-detection/testScipTreemapAnomalyDetection.py`

Reference: `domains/external-dependencies/testExternalScipDependencyCharts.py`

Tests (all mock-based, no Neo4j required):
1. `test_remove_last_path_file_extension()` — empty list, 1-element, multi-element with extension
2. `test_join_path_elements()` — path hierarchy from split list
3. `test_add_element_path_column()` — DataFrame gets exploded column; already-exists skips
4. `test_add_element_name_column()` — short name extraction from path
5. `test_add_parent_directory_column()` — parent path extraction
6. `test_prepare_data_for_treemap()` — full pipeline: input DataFrame → expected column shape
7. `test_save_treemap_figure()` — mock `plotly.graph_objects.Figure.write_image`, verify call with correct file path
8. `test_empty_data_skips_figure()` — empty DataFrame → no write_image call

Run: `pytest domains/anomaly-detection/testScipTreemapAnomalyDetection.py -v`

---

## Phase 9 — README update (independent)

`domains/anomaly-detection/README.md`:
- Add "SCIP Support" section listing 3 abstraction levels and their weight property (`referenceCount`)
- Note: 15-node minimum in the Python ML pipeline; Artifact level skipped automatically when below threshold
- Note: treemap SVGs generated for InternalType level only (has `file` path property)
- Add new files to Folder Structure entries
- Reference `AnomalyDetectionScipExploration.ipynb`

---

## Files Changed

### New files (9)
- `domains/anomaly-detection/features/AnomalyDetectionFeature_Abstractness_ScipInternalType.cypher`
- `domains/anomaly-detection/features/AnomalyDetectionFeature_Abstractness_ScipModule.cypher`
- `domains/anomaly-detection/features/AnomalyDetectionFeature_Abstractness_ScipArtifact.cypher`
- `domains/anomaly-detection/scipTreemapAnomalyDetection.py`
- `domains/anomaly-detection/testScipTreemapAnomalyDetection.py`
- `domains/anomaly-detection/explore/AnomalyDetectionScipExploration.ipynb`
- (3 SVG output files generated at runtime — not committed)

### Modified files (5) — additive only
- `domains/anomaly-detection/anomalyDetectionCsv.sh` — add 3 SCIP blocks
- `domains/anomaly-detection/anomalyDetectionPython.sh` — add 3 SCIP blocks + `anomaly_detection_scip_treemap_charts()` function
- `domains/anomaly-detection/graphs/anomalyDetectionGraphs.sh` — add 3 SCIP calls
- `domains/anomaly-detection/summary/anomalyDetectionSummary.sh` — add 3 SCIP calls
- `domains/anomaly-detection/README.md` — add SCIP section

### Unchanged (parameterized, work as-is)
- All `features/AnomalyDetectionFeature-*.cypher` — use `$projection_node_label`
- All `labels/*.cypher` — use `$projection_node_label`
- All `reset/*.cypher` — use `$projection_node_label`
- `queries/AnomalyDetectionNodeCount.cypher` — uses `$projection_node_label` + `$projection_weight_property`
- `graphs/TopBridge.cypher`, `TopOutlier.cypher`, `TopCentral.template.gv`
- All Python ML pipeline scripts (tunedLeidenCommunityDetection.py, tunedNodeEmbeddingClustering.py, umap2dNodeEmbeddings.py, tunedAnomalyDetectionExplained.py, anomalyDetectionFeaturePlots.py) — use `$projection_node_label` in queries
- All `summary/*.cypher`

---

## Verification

### Static (no dependencies)
1. `shellcheck domains/anomaly-detection/anomalyDetectionCsv.sh`
2. `shellcheck domains/anomaly-detection/anomalyDetectionPython.sh`
3. `shellcheck domains/anomaly-detection/graphs/anomalyDetectionGraphs.sh`
4. `shellcheck domains/anomaly-detection/summary/anomalyDetectionSummary.sh`
5. Pylance type checking on `scipTreemapAnomalyDetection.py`
6. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/anomaly-detection/README.md`

### Unit tests (no Neo4j)
7. `pytest domains/anomaly-detection/testScipTreemapAnomalyDetection.py -v`

### Integration (requires Neo4j + SCIP data)
8. `analyze.sh --domain anomaly-detection --report Csv --keep-running` — verify SCIP sub-directories created under `reports/anomaly-detection/`
9. `analyze.sh --domain anomaly-detection --report Python --keep-running` — verify SCIP treemap SVGs generated for InternalType
10. `analyze.sh --domain anomaly-detection --report Visualization --keep-running` — verify graph SVGs for SCIP levels
11. `analyze.sh --domain anomaly-detection --report Markdown --keep-running` — verify SCIP sections appear in report

### When no SCIP data present
- All static + unit tests pass
- Integration tests 8-11 complete without error: SCIP directories not created (empty cleanup), SCIP summary sections skipped
