//3 Topological Sort Artifacts
//Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream('artifact-dependencies-directed-without-empty',{     
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
   WITH nodeId
       ,gds.util.asNode(nodeId)           AS artifact
       ,toInteger(maxDistanceFromSource)  AS maxDistanceFromSource
    SET artifact.maxDistanceFromSource = maxDistanceFromSource
   WITH COLLECT(nodeId)                   AS sortedNodeIds
       ,COLLECT(artifact)                 AS sortedArtifacts
       ,MAX(maxDistanceFromSource)        AS overallMaxDistance
FOREACH (i IN RANGE(0, SIZE(sortedArtifacts)-1) | 
    SET gds.util.asNode(sortedNodeIds[i]).topologicalSortIndex = i)
 RETURN size(sortedArtifacts) AS numberOfArtifacts, overallMaxDistance