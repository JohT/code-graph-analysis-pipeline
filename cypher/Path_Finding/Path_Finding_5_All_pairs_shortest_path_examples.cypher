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
// Optionally get the project (e.g. Java Artifact, Typescript Project) the source and target belong to
OPTIONAL MATCH (sourceProject:Artifact|Project)-[:CONTAINS]->(source)
// Optionally get the name of the scan that contained that project
OPTIONAL MATCH (sourceScan:TS:Scan)-[:CONTAINS_PROJECT]->(sourceProject)
   WITH *, coalesce(sourceScan, sourceProject).name AS sourceContainerName
 ORDER BY distance DESC, sourceContainerName ASC
// Only output the top 10 entries
 LIMIT 10
// Get the shortest path for the source and target node
 MATCH path = SHORTEST 1 (source)-[:DEPENDS_ON]->+(target)
RETURN distance, sourceContainerName, sourceProject, sourceScan, path