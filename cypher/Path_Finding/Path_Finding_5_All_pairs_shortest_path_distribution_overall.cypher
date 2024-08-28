// Path Finding - All pairs shortest path algorithm - Stream - Overall

  CALL gds.allShortestPaths.stream($dependencies_projection + '-cleaned')
 YIELD sourceNodeId, targetNodeId, distance
 WHERE gds.util.isFinite(distance) = true
  WITH gds.util.asNode(sourceNodeId) AS source
      ,gds.util.asNode(targetNodeId) AS target
      ,toInteger(distance)           AS distance
      ,sourceNodeId
      ,targetNodeId
 WHERE sourceNodeId <> targetNodeId
RETURN distance
      ,count(*)                     AS pairCount
      ,count(DISTINCT sourceNodeId) AS sourceNodeCount
      ,count(DISTINCT targetNodeId) AS targetNodeCount
      ,collect(DISTINCT source.fileName + ' ->' + target.fileName)[0..2] AS examples
ORDER BY distance