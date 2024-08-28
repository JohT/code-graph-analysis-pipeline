// Path Finding - All pairs shortest path algorithm - Stream - Per project

  CALL gds.allShortestPaths.stream($dependencies_projection + '-cleaned')
 YIELD sourceNodeId, targetNodeId, distance
// Filter out all pairs that have no connection (infinite distance)
 WHERE gds.util.isFinite(distance) = true
  WITH toInteger(distance) AS distance
      ,sourceNodeId
      ,targetNodeId
 WHERE sourceNodeId  <> targetNodeId // Filter out cyclic dependencies
// Group by distance to get the overall distribution
  WITH distance
      ,count(*)                     AS distanceTotalPairCount
      ,count(DISTINCT sourceNodeId) AS distanceTotalSourceCount
      ,count(DISTINCT targetNodeId) AS distanceTotalTargetCount
      ,collect({sourceNodeId: sourceNodeId, targetNodeId: targetNodeId}) AS sourcesAndTargets
// Unwind group to get every corresponding distance, source and target again
UNWIND sourcesAndTargets AS sourceAndTarget
  WITH *
      ,sourceAndTarget.sourceNodeId AS sourceNodeId
      ,sourceAndTarget.targetNodeId AS targetNodeId
// Resolve node ids to actual nodes
  WITH *
      ,gds.util.asNode(sourceNodeId) AS source
      ,gds.util.asNode(targetNodeId) AS target
// Optionally get the project (e.g. Java Artifact, Typescript Project) the source and target belong to
OPTIONAL MATCH (sourceProject:Artifact|Project)-[:CONTAINS]->(source)
OPTIONAL MATCH (targetProject:Artifact|Project)-[:CONTAINS]->(target)
// Group by project name, if the target project is the same and the distance. Return those as result.
RETURN sourceProject.name               AS sourceProject
      ,(targetProject <> sourceProject) AS isDifferentTargetProject
      ,distance
      ,distanceTotalPairCount
      ,distanceTotalSourceCount
      ,distanceTotalTargetCount
      ,count(*)                         AS pairCount
      ,count(DISTINCT sourceNodeId)     AS sourceNodeCount
      ,count(DISTINCT targetNodeId)     AS targetNodeCount
      ,collect(DISTINCT source.fileName + ' ->' + target.fileName)[0..4] AS examples
// Sort by source project name, if the target project is the same and the distance, all ascending
ORDER BY sourceProject, isDifferentTargetProject, distance