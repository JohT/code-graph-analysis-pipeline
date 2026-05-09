# Plan: Create `archetypes` Domain from `anomaly-detection`

Split out a new lightweight domain that extracts the Cypher-only graph archetype classification and heuristic structural queries, keeping the ML/Python pipeline isolated in `anomaly-detection`.

---

**TL;DR**: Create `domains/archetypes/` as a fully self-contained domain (Csv + Visualization + Markdown). It owns Authority/Bottleneck/Hub archetype labeling (renamed from Anomaly → Archetype prefix), and the 9 heuristic structural queries. `anomaly-detection` is updated to use the new property names and writes archetype labels conditionally (skip if archetypes domain already ran). Bridge and Outlier stay `Mark4TopAnomalyBridge`/`anomalyBridgeRank` (ML-only).

---

## Phase 1: Create `domains/archetypes/` (all new files)

### 1. Entry point scripts

1. **`domains/archetypes/archetypesCsv.sh`** — orchestrates `archetype_features()` → `archetype_labels()` → `archetype_queries()` → CSV reports. Modeled on `anomalyDetectionCsv.sh`.
2. **`domains/archetypes/archetypesVisualization.sh`** — thin wrapper → `graphs/archetypesGraphs.sh`
3. **`domains/archetypes/archetypesMarkdown.sh`** — thin wrapper → `summary/archetypesSummary.sh`

### 2. `domains/archetypes/features/` *(self-contained copies of all 30 feature Cypher files from `anomaly-detection/features/`)*

Copy all Betweenness, LocalClusteringCoefficient, PageRank, ArticleRank, PageToArticleRank, Abstractness, SCC, WCC, TopologicalSort pairs + `Set_Parameters_Manual.cypher`. 

**Do NOT copy**: `AnomalyDetectionFeatures.cypher` (the master query that includes `anomalyLabel`/`anomalyScore`).

### 3. `domains/archetypes/labels/` *(new, with Archetype-prefixed property names)*

- **`ArchetypeAuthority.cypher`** — sets `Mark4TopArchetypeAuthority`, `archetypeAuthorityRank`
- **`ArchetypeBottleneck.cypher`** — sets `Mark4TopArchetypeBottleneck`, `archetypeBottleneckRank`
- **`ArchetypeHub.cypher`** — sets `Mark4TopArchetypeHub`, `archetypeHubRank`
- **`ArchetypeRemoveLabels.cypher`** — removes only the 3 Archetype* labels + their rank properties
- **`ArchetypeAuthority-Exists.cypher`, `ArchetypeBottleneck-Exists.cypher`, `ArchetypeHub-Exists.cypher`** — return a row if rank already set (for skip-if-exists pattern)

**Note**: No Bridge/Outlier label files (those stay in `anomaly-detection` only, ML-dependent).

### 4. `domains/archetypes/queries/` *(MOVED from `anomaly-detection/queries/`)*

Move (delete from anomaly-detection): all 9 heuristic structural queries + `AnomalyDetectionProjectionStatistics.cypher`:
- `AnomalyDetectionDependencyHungryOrchestrators.cypher`
- `AnomalyDetectionPopularBottlenecks.cypher`
- `AnomalyDetectionSilentCoordinators.cypher`
- `AnomalyDetectionPotentialImbalancedRoles.cypher`
- `AnomalyDetectionHiddenBridgeNodes.cypher`
- `AnomalyDetectionFragileStructuralBridges.cypher`
- `AnomalyDetectionPotentialOverEngineerOrIsolated.cypher`
- `AnomalyDetectionUnexpectedCentralNodes.cypher`
- `AnomalyDetectionOverReferencesUtilities.cypher`
- `AnomalyDetectionProjectionStatistics.cypher`

**Keep in both**: `AnomalyDetectionNodeCount.cypher` (still used by anomaly-detection Python pipeline).

### 5. `domains/archetypes/graphs/` *(new GraphViz visualization — no anomalyScore)*

- **`archetypesGraphs.sh`** — orchestration (modeled on `anomalyDetectionGraphs.sh`)
- **`TopAuthority.cypher`, `TopBottleneck.cypher`, `TopHub.cypher`** — adapted from anomaly-detection counterparts using `archetypeAuthorityRank` / `archetypeBottleneckRank` / `archetypeHubRank`
- **`TopCentral.template.gv`** — copy from `anomaly-detection/graphs/`

### 6. `domains/archetypes/summary/` *(new Markdown report)*

- **`archetypesSummary.sh`**
- **`ArchetypesInTotal.cypher`** — archetype counts only (no `anomalyLabel`)
- **`ArchetypesPerAbstractionLayer.cypher`**
- **`ArchetypeDeepDiveArchetypes.cypher`** — matches `archetype*Rank` properties only
- **`report.template.md`, `report_no_archetype_data.template.md`, `report_no_dependency_data.template.md`**

### 7. `domains/archetypes/README.md`

---

## Phase 2: Update `domains/anomaly-detection/` (minimal changes)

### 1. Rename Authority/Bottleneck/Hub properties in-place *(Bridge/Outlier unchanged)*

| Old | New |
|-----|-----|
| `Mark4TopAnomalyAuthority` | `Mark4TopArchetypeAuthority` |
| `Mark4TopAnomalyBottleneck` | `Mark4TopArchetypeBottleneck` |
| `Mark4TopAnomalyHub` | `Mark4TopArchetypeHub` |
| `anomalyAuthorityRank` | `archetypeAuthorityRank` |
| `anomalyBottleneckRank` | `archetypeBottleneckRank` |
| `anomalyHubRank` | `archetypeHubRank` |

Files touched: `labels/AnomalyDetectionArchetype{Authority,Bottleneck,Hub}.cypher`

### 2. Update `labels/AnomalyDetectionArchetypeRemoveLabels.cypher`

Remove only `Mark4TopAnomalyBridge` and `Mark4TopAnomalyOutlier` — no longer removes Authority/Bottleneck/Hub (owned by archetypes domain now).

### 3. Add Exists check files to `labels/`

`AnomalyDetectionArchetypeAuthority-Exists.cypher`, `..Bottleneck-Exists.cypher`, `..Hub-Exists.cypher` — return row if `archetypeAuthorityRank IS NOT NULL` etc.

### 4. Update `anomalyDetectionCsv.sh`

- Remove `anomaly_detection_queries()` function body and its call from `anomaly_detection_csv_reports()`
- Change Authority/Bottleneck/Hub label writes from direct `execute_cypher` → `execute_cypher_queries_until_results` (Exists → Write), matching the feature check pattern

### 5. Update references to renamed properties *(7 files)*

- **`summary/AnomaliesInTotal.cypher`, `AnomaliesPerAbstractionLayer.cypher`, `AnomaliesDeepDiveOverview.cypher`** — direct property references
- **`summary/AnomaliesDeepDiveArchetypes.cypher` + `AnomalyDeepDiveTopAnomalies.cypher`** — dynamic key matching (`STARTS WITH 'anomaly' AND ENDS WITH 'Rank'`): update to also match `STARTS WITH 'archetype' AND ENDS WITH 'Rank'` via `OR`
- **`graphs/TopAuthority.cypher`, `TopBottleneck.cypher`, `TopHub.cypher`** — rank property in `WHERE` and `label` expressions
- **`queries/AnomalyDetectionFiles.cypher`** — uses both `anomalyScore` AND the renamed rank properties
- **`treemapVisualizations.py`** — inline Cypher using `anomalyAuthorityRank` etc.

### 6. Delete the 10 moved Cypher files from `anomaly-detection/queries/`

---

## Verification

1. `shellcheck domains/archetypes/archetypesCsv.sh domains/archetypes/archetypesVisualization.sh domains/archetypes/archetypesMarkdown.sh`
2. `shellcheck domains/anomaly-detection/anomalyDetectionCsv.sh`
3. `analyze.sh --domain archetypes --report Csv --keep-running`
4. `analyze.sh --domain archetypes --report Visualization --keep-running`
5. `analyze.sh --domain archetypes --report Markdown --keep-running`
6. `analyze.sh --domain anomaly-detection --report Csv --keep-running` — verify heuristic queries no longer run from anomaly-detection, archetype labels are conditional
7. Grep check: no `anomalyAuthorityRank`, `anomalyBottleneckRank`, `anomalyHubRank`, `Mark4TopAnomalyAuthority/Bottleneck/Hub` anywhere (except explore notebooks, which are non-critical)
8. Markdown link check on `domains/archetypes/README.md`

---

## Decisions

- **CI/CD**: archetypes is auto-discovered by compilation scripts via `*Csv.sh` / `*Markdown.sh` / `*Visualization.sh` filename patterns — no workflow changes needed
- **Domain defaults**: `archetypes` is NOT in the defaults-skipped list (`anomaly-detection`, `node-embeddings`, `graph-algorithms`) — it runs by default like `internal-dependencies`
- **Exploration notebooks**: not updated (not pipeline-critical)
- **`AnomalyDetectionFeatures.cypher`**: master features file with anomalyLabel stays in anomaly-detection only
- **Property names**: Bridge/Outlier keep `Mark4TopAnomalyBridge`/`anomalyBridgeRank` (ML-only); Authority/Bottleneck/Hub renamed to Archetype prefix

---

## Further Considerations

1. **anomaly-detection visualization duplication**: After the split, both `archetypes` and `anomaly-detection` will generate Authority/Bottleneck/Hub GraphViz SVGs into their respective report directories. These go to different paths so they don't literally conflict, but it's some duplication. Should anomaly-detection's graph scripts be updated to skip Authority/Bottleneck/Hub and only render Bridge/Outlier?
   - *Recommendation: leave anomaly-detection graphs untouched ("mostly as is"), since Bridge/Outlier graphs don't exist yet in the pipeline.*

2. **AGENTS.md domain list**: Currently lists `anomaly-detection, external-dependencies, git-history, internal-dependencies, java` as domains. Add `archetypes`!