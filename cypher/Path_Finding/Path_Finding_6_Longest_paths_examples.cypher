// Path Finding - Longest path - Stream - Max. paths as examples

  CALL gds.dag.longestPath.stream($dependencies_projection + '-cleaned')
 YIELD index, sourceNode, targetNode, totalCost, path
  WITH index
      ,path
      ,toInteger(totalCost)          AS distance
      ,sourceNode                    AS sourceNodeId
      ,targetNode                    AS targetNodeId
 WHERE sourceNodeId  <> targetNodeId // Filter out cyclic dependencies
  WITH *
      ,gds.util.asNode(sourceNodeId) AS source
      ,gds.util.asNode(targetNodeId) AS target   
// Optionally get the project (e.g. Java Artifact, Typescript Project) the source and target belong to
OPTIONAL MATCH (sourceProject:Artifact|Project)-[:CONTAINS]->(source)
OPTIONAL MATCH (targetProject:Artifact|Project)-[:CONTAINS]->(target)
// Optionally get the name of the scan that contained that project
OPTIONAL MATCH (sourceScan:TS:Scan)-[:CONTAINS_PROJECT]->(sourceProject)
OPTIONAL MATCH (targetScan:TS:Scan)-[:CONTAINS_PROJECT]->(targetProject)
   WITH *, coalesce(sourceScan, sourceProject).name AS sourceContainerName
 ORDER BY distance DESC, sourceContainerName ASC
// Only output the top 10 entries
 LIMIT 10
// Group by project name, if the target project is the same and the distance. Return those as result.
RETURN distance, index, sourceContainerName, sourceProject, sourceScan, path