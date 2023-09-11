//3 Topological Sort Artifacts as list
//Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream('artifact-dependencies-directed-without-empty',{     
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
   WITH nodeId
       ,gds.util.asNode(nodeId)           AS artifact
       ,toInteger(maxDistanceFromSource)  AS maxDistanceFromSource
    SET artifact.maxDistanceFromSource = maxDistanceFromSource
   WITH COLLECT(nodeId)                   AS sortedNodeIds
       ,COLLECT({artifact: artifact, maxDistanceFromSource: maxDistanceFromSource}) AS topologicalSortedArtifacts
       ,MAX(maxDistanceFromSource)        AS overallMaxDistance
FOREACH (i IN RANGE(0, SIZE(sortedNodeIds)-1) | 
    SET gds.util.asNode(sortedNodeIds[i]).topologicalSortIndex = i)
   WITH topologicalSortedArtifacts
       ,overallMaxDistance
 UNWIND topologicalSortedArtifacts        AS topologicalSortedArtifact
 RETURN replace(last(split(topologicalSortedArtifact.artifact.fileName, '/')), '.jar', '') AS artifactName
       ,topologicalSortedArtifact.maxDistanceFromSource                                    AS buildLevel
       ,overallMaxDistance                                                                 AS overalNumberOfBuildLevels