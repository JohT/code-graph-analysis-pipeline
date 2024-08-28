// Longest paths distribution

  CALL gds.dag.longestPath.stream($dependencies_projection + '-cleaned')
 YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN toInteger(totalCost) AS totalCost
      ,count(*)             AS nodeCount
ORDER BY totalCost