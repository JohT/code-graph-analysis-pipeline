// Topological Sort to write the properties "topologicalSortMaxDistanceFromSource" and "topologicalSortIndex" for strongly connected components. Requires "SCC_TopologicalSort_Projection.cypher".
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
