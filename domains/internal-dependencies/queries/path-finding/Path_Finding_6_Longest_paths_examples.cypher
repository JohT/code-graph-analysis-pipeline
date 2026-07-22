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
   WITH *, coalesce(source.rootProjectName, source.projectName, source.name) AS sourceContainerName
 ORDER BY distance DESC, sourceContainerName ASC
// Only output the top 10 entries
 LIMIT 10
// Group by project name, if the target project is the same and the distance. Return those as result.
RETURN distance, index, sourceContainerName, source.projectName, path