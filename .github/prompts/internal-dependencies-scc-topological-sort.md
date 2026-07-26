# Internal Dependencies: SCC-Aware Topological Sort + SCIP Path Finding

## Overview

**Problem:** Topological Sort only works on directed acyclic graphs (DAGs). In cyclic dependencies, Neo4j GDS excludes nodes that are part of cycles from the result. This leaves architecture insights incomplete.

**Solution:** Detect strongly connected components (SCCs) first → run topological sort on the component graph → propagate results back to member nodes. This ensures all nodes get proper ordering values.

**Side goal:** Add path-finding (all-pairs shortest path + longest path) for SCIP semantic index modules and artifacts.

---

## Architecture

```
┌─ Input: Dependency graph with cycles ─┐
│                                         │
│  Run PageRank? NO → Use degree-based   │
│  Find SCC nodes + edges                │
│  Topo sort SCC graph                   │
│  Propagate maxDistanceFromSource       │
│  + topologicalSortIndex back to members│
│                                         │
└─ Output: All nodes have sort values ──┘
```

### Key Design Decisions

1. **Replace, not augment** — The existing `topologicalSort()` function is replaced entirely. No need to run both direct sort and SCC sort.
2. **Degree-based SCC naming** — For each SCC, pick the member with highest `degree(DEPENDS_ON)` as the representative node name. Avoids expensive PageRank computation.
3. **Both properties propagated** — `maxDistanceFromSource` (build layer) + `topologicalSortIndex` (order within layer); cycle members share the same index value.
4. **SCIP path-finding** — Add `SemanticCodeIndexModule` and `SemanticCodeIndexArtifact` to path-finding pipeline using `SCIP_Semantic_Index` language tag.
5. **Exists guards** — Check for both `topologicalSortMaxDistanceFromSource` AND `topologicalSortIndex` on SCC component nodes before re-running.

---

## Implementation Steps

### Phase 1: New Cypher Queries

Create directory: `domains/internal-dependencies/queries/topological-sort/strongly-connected-components/`

#### 1. `SCC_Exists.cypher`
Check if SCC computation has already run.
```cypher
// Return first node with communityStronglyConnectedComponentId if it exists
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
RETURN codeUnit.name AS shortCodeUnitName
      ,elementId(codeUnit) AS nodeElementId
      ,codeUnit.communityStronglyConnectedComponentId AS sccId
LIMIT 1
```

#### 2. `SCC_Write.cypher`
Compute and write SCC IDs to all nodes.
```cypher
// Calculates and writes the Strongly Connected Components
CALL gds.scc.write(
 $dependencies_projection + '-directed-cleaned', {
    writeProperty: 'communityStronglyConnectedComponentId',
    consecutiveIds: true
})
YIELD componentCount, nodePropertiesWritten, preProcessingMillis, computeMillis,
      postProcessingMillis, writeMillis, componentDistribution
RETURN componentCount, nodePropertiesWritten,
       componentDistribution.min, componentDistribution.mean, componentDistribution.max,
       componentDistribution.p50, componentDistribution.p75, componentDistribution.p90,
       componentDistribution.p95, componentDistribution.p99, componentDistribution.p999
```

#### 3. `SCC_CreateNode.cypher`
Create SCC component nodes, named after the highest-degree member (not PageRank).
```cypher
// Create nodes for strongly connected components and connect them to their members.
// Requires: SCC_Write.cypher

// 1) Select all code units that belong to a strongly connected component
//    and sort by degree (in + out dependencies) for representative naming
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
WITH codeUnit,
     size((codeUnit)-[:DEPENDS_ON]->()) + size((codeUnit)<-[:DEPENDS_ON]-()) AS totalDegree
ORDER BY totalDegree DESC

// 2) Group code units by strongly connected component id
WITH codeUnit.communityStronglyConnectedComponentId AS componentId
    ,collect(codeUnit) AS members
    ,count(codeUnit) AS componentSize

// 3) Create or update the StronglyConnectedComponent node
//    - size: number of code units in the component
//    - name: derived from the highest-degree member
MERGE (component:StronglyConnectedComponent {id: componentId, memberType: $dependencies_projection_node})
WITH *
    ,CASE componentSize WHEN = 1 THEN 'Component ' ELSE 'Cycle around ' END AS componentNamePrefix
CALL apoc.create.addLabels(component, [$dependencies_projection_node + 'Members']) YIELD node
SET component.size = componentSize
   ,component.name = componentNamePrefix + members[0].name

// 4-5) Connect the code units to the StronglyConnectedComponent they belong to
WITH component, members
UNWIND members AS codeUnit
MERGE (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component)
```

#### 4. `SCC_CreateDependency.cypher`
Create component-level DEPENDS_ON edges (aggregate weights).
```cypher
// Create edges between strongly connected components.
// Requires: SCC_CreateNode.cypher

MATCH (sourceCodeUnit)-[codeUnitDependency:DEPENDS_ON]->(targetCodeUnit)
WHERE $dependencies_projection_node IN labels(sourceCodeUnit)
  AND $dependencies_projection_node IN labels(targetCodeUnit)
MATCH (sourceCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(sourceComponent:StronglyConnectedComponent)
MATCH (targetCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(targetComponent:StronglyConnectedComponent)
WHERE sourceComponent <> targetComponent
WITH sourceComponent, targetComponent
    ,count(*) AS weightCount
    ,sum(codeUnitDependency.weight) AS weight
    ,CASE $dependencies_projection_weight_property
          WHEN '' THEN sum(codeUnitDependency.weight)
          ELSE sum(codeUnitDependency[$dependencies_projection_weight_property])
     END AS weightSelected

MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
SET componentDependency.weightCount = weightCount
   ,componentDependency.weight = weight
   ,componentDependency[$dependencies_projection_weight_property] = weightSelected
```

#### 5. `SCC_TopologicalSort_Exists.cypher`
Check if topological sort on components has been done (both properties required).
```cypher
// Return first component with both topologicalSortMaxDistanceFromSource AND topologicalSortIndex if they exist
MATCH (component:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(component)
  AND component.topologicalSortMaxDistanceFromSource IS NOT NULL
  AND component.topologicalSortIndex IS NOT NULL
RETURN component.name AS shortCodeUnitName
      ,elementId(component) AS nodeElementId
      ,component.topologicalSortMaxDistanceFromSource AS topologicalSortMaxDistanceFromSource
      ,component.topologicalSortIndex AS topologicalSortIndex
LIMIT 1
```

#### 6. `SCC_TopologicalSort_Delete_Projection.cypher`
Clean up previous projection if it exists.
```cypher
// Delete projection if existing
CALL gds.graph.drop($dependencies_projection + '-components', false)
YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime
```

#### 7. `SCC_TopologicalSort_Projection.cypher`
Create in-memory projection of the SCC graph.
```cypher
// Creates a projection of the strongly connected components graph for the given member type.
// Requires: SCC_CreateDependency.cypher

MATCH (sourceComponent:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(sourceComponent)
OPTIONAL MATCH (sourceComponent)-[:DEPENDS_ON]->(targetComponent:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(targetComponent)
WITH gds.graph.project($dependencies_projection + '-components', sourceComponent, targetComponent) AS graph
RETURN graph.graphName AS graphName
      ,graph.nodeCount AS nodeCount
      ,graph.relationshipCount AS relationshipCount
```

#### 8. `SCC_TopologicalSort_Write.cypher`
Run topological sort on SCC graph, write both properties to components.
```cypher
// Topological Sort on strongly connected components. Requires: SCC_TopologicalSort_Projection.cypher
// Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream(
 $dependencies_projection + '-components', {
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
WITH nodeId,
     gds.util.asNode(nodeId) AS component,
     toInteger(maxDistanceFromSource) AS maxDistanceFromSource
SET component.topologicalSortMaxDistanceFromSource = maxDistanceFromSource

WITH collect(nodeId) AS sortedNodeIds,
     max(maxDistanceFromSource) AS overallMaxDistance
FOREACH (i IN range(0, SIZE(sortedNodeIds) - 1) |
  SET gds.util.asNode(sortedNodeIds[i]).topologicalSortIndex = i)

WITH overallMaxDistance, SIZE(sortedNodeIds) AS componentCount
RETURN componentCount, overallMaxDistance
```

#### 9. `SCC_TopologicalSort_Propagate.cypher` (NEW)
Propagate `maxDistanceFromSource` and `topologicalSortIndex` from SCC components back to member nodes.
```cypher
// Propagate topological sort results from SCC components back to their member nodes.
// Requires: SCC_TopologicalSort_Write.cypher

MATCH (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component:StronglyConnectedComponent)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND component.topologicalSortMaxDistanceFromSource IS NOT NULL
  AND component.topologicalSortIndex IS NOT NULL
SET codeUnit.maxDistanceFromSource = component.topologicalSortMaxDistanceFromSource
   ,codeUnit.topologicalSortIndex = component.topologicalSortIndex

RETURN count(codeUnit) AS membersUpdated
      ,count(DISTINCT component) AS componentsProcessed
```

#### 10-11. SCIP Path-Finding Parameters

**`Set_Parameters_SCIP_Module.cypher`**
```cypher
:params {
    "dependencies_projection_language": "SCIP_Semantic_Index",
    "dependencies_projection": "scip-module-path-finding",
    "dependencies_projection_node": "SemanticCodeIndexModule",
    "dependencies_projection_weight_property": "referenceCount"
}
```

**`Set_Parameters_SCIP_Artifact.cypher`**
```cypher
:params {
    "dependencies_projection_language": "SCIP_Semantic_Index",
    "dependencies_projection": "scip-artifact-path-finding",
    "dependencies_projection_node": "SemanticCodeIndexArtifact",
    "dependencies_projection_weight_property": "referenceCount"
}
```

---

### Phase 2: Update `internalDependenciesCsv.sh`

#### A. Replace `topologicalSort()` function with `sccAwareTopologicalSort()`

```bash
# Apply topological sort on strongly connected components for all node types.
# This ensures nodes that are part of cycles still receive sort values.
#
# Required Parameters:
# - dependencies_projection=...      Name prefix for the in-memory projection
# - dependencies_projection_node=... Node label (e.g., "Artifact", "Package")
# - dependencies_projection_weight_property=... Weight property name
sccAwareTopologicalSort() {
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )

    # 1. Detect SCC
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_Write.cypher" \
        "${@}"

    # 2. Create SCC nodes + component-level dependencies
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_CreateNode.cypher" "${@}"
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_CreateDependency.cypher" "${@}"

    # 3. Topological sort on SCC graph (with projection lifecycle)
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Delete_Projection.cypher" \
        "${@}"
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Projection.cypher" \
        "${@}"
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Write.cypher" \
        "${@}"

    # 4. Propagate sort values back to member nodes
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/strongly-connected-components/SCC_TopologicalSort_Propagate.cypher" "${@}"

    # 5. Stream to CSV
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Query.cypher" "${@}" \
        > "${CURRENT_LEVEL_DIR}/${nodeLabel}_Topological_Sort.csv"
}
```

#### B. Update all `topologicalSort` call sites

Replace:
```bash
topologicalSort "${PROJECTION}" "${NODE}" "${WEIGHT}"
```

With:
```bash
sccAwareTopologicalSort "${PROJECTION}" "${NODE}" "${WEIGHT}"
```

Locations (9 total):
1. Java Artifact Topological Sort
2. Java Package Topological Sort
3. Java Type Topological Sort
4. TypeScript Module Topological Sort
5. NPM Non-Dev Package Topological Sort
6. NPM Dev Package Topological Sort
7. SCIP Semantic Index Type Topological Sort
8. SCIP Semantic Index Module Topological Sort
9. SCIP Semantic Index Artifact Topological Sort

#### C. Add SCIP path-finding sections

Add two new sections after the "Dev NPM Package Path Finding" section and before "Topological Sort":

```bash
# -- SCIP Semantic Index Module Path Finding ----

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"
mkdir -p "${CURRENT_LEVEL_DIR}"
SCIP_MODULE_LANGUAGE="dependencies_projection_language=SCIP_Semantic_Index"
SCIP_MODULE_PROJECTION="dependencies_projection=scip-module-path-finding"
SCIP_MODULE_NODE="dependencies_projection_node=SemanticCodeIndexModule"
SCIP_MODULE_WEIGHT="dependencies_projection_weight_property=referenceCount"

if createDirectedDependencyProjection "${SCIP_MODULE_LANGUAGE}" "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}"; then
    runPathFindingAlgorithms "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}"
fi

# -- SCIP Semantic Index Artifact Path Finding --

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Artifact"
mkdir -p "${CURRENT_LEVEL_DIR}"
SCIP_ARTIFACT_LANGUAGE="dependencies_projection_language=SCIP_Semantic_Index"
SCIP_ARTIFACT_PROJECTION="dependencies_projection=scip-artifact-path-finding"
SCIP_ARTIFACT_NODE="dependencies_projection_node=SemanticCodeIndexArtifact"
SCIP_ARTIFACT_WEIGHT="dependencies_projection_weight_property=referenceCount"

if createDirectedDependencyProjection "${SCIP_ARTIFACT_LANGUAGE}" "${SCIP_ARTIFACT_PROJECTION}" "${SCIP_ARTIFACT_NODE}" "${SCIP_ARTIFACT_WEIGHT}"; then
    runPathFindingAlgorithms "${SCIP_ARTIFACT_PROJECTION}" "${SCIP_ARTIFACT_NODE}" "${SCIP_ARTIFACT_WEIGHT}"
fi
```

---

## Verification

1. **Shell syntax:**
   ```bash
   shellcheck domains/internal-dependencies/internalDependenciesCsv.sh
   ```

2. **Cypher queries:**
   ```bash
   # Requires Neo4j running
   ./scripts/executeQuery.sh domains/internal-dependencies/queries/topological-sort/strongly-connected-components/SCC_Exists.cypher
   ```

3. **End-to-end test:**
   ```bash
   analyze.sh --domain internal-dependencies --report Csv --keep-running
   ```

4. **Validation checks:**
   - Nodes previously excluded from results (cycle members) now have `maxDistanceFromSource` and `topologicalSortIndex`
   - CSV output includes cycle members with proper sort values
   - SCIP path-finding CSV files exist in `SCIP_Semantic_Index_Module/` and `SCIP_Semantic_Index_Artifact/`

---

## Trade-offs

| Decision | Rationale |
|----------|-----------|
| Degree-based SCC naming | Fast (~no extra computation); degree is a reasonable proxy for architectural importance |
| Both properties propagated | Enables full layer-by-layer visualization; cycle members get same index within their SCC |
| Replace (not augment) | Simpler; avoids conflicts; cycles are handled correctly without fallback |
| SCIP path-finding inclusion | Improves consistency across all node types; reuses same `referenceCount` weight property |

---

## References

- **Anomaly-detection SCC queries:** `domains/anomaly-detection/features/AnomalyDetectionFeature-StronglyConnectedComponents-*.cypher`
- **Existing topological sort:** `domains/internal-dependencies/queries/topological-sort/Topological_Sort_*.cypher`
- **Path-finding pattern:** `domains/internal-dependencies/queries/path-finding/Set_Parameters_*.cypher`
