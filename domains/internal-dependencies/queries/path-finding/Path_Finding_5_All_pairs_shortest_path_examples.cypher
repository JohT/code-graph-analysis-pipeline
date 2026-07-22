// Path Finding - All pairs shortest path algorithm - Stream - Longest paths as examples

  CALL gds.allShortestPaths.stream($dependencies_projection + '-cleaned')
 YIELD sourceNodeId, targetNodeId, distance
// Filter out all pairs that have no connection (infinite distance)
 WHERE gds.util.isFinite(distance) = true
   AND sourceNodeId  <> targetNodeId // Filter out cyclic dependencies
  WITH toInteger(distance) AS distance
      ,sourceNodeId
      ,targetNodeId
      ,gds.util.asNode(sourceNodeId) AS source
      ,gds.util.asNode(targetNodeId) AS target
   WITH *, coalesce(source.rootProjectName, source.projectName, source.name) AS sourceContainerName
 ORDER BY distance DESC, sourceContainerName ASC
// Only output the top 10 entries
 LIMIT 10
// Get the shortest path for the source and target node
 MATCH path = SHORTEST 1 (source)-[:DEPENDS_ON]->+(target)
RETURN distance, sourceContainerName, source.projectName, path