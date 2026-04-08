// Topological Sort to write the properties topologicalSortIndex (e.g. build order) and maxDistanceFromSource (build level) into the graph.
// Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream(
 $dependencies_projection + '-cleaned', {
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
   WITH nodeId
       ,gds.util.asNode(nodeId)           AS codeUnit
       ,toInteger(maxDistanceFromSource)  AS maxDistanceFromSource
    SET codeUnit.maxDistanceFromSource = maxDistanceFromSource
   WITH collect(nodeId)                   AS sortedNodeIds
       ,collect(codeUnit)                 AS sortedArtifacts
       ,max(maxDistanceFromSource)        AS overallMaxDistance
FOREACH (i IN range(0, SIZE(sortedArtifacts)-1) | 
    SET gds.util.asNode(sortedNodeIds[i]).topologicalSortIndex = i)
 RETURN size(sortedArtifacts) AS numberOfArtifacts, overallMaxDistance