// Longest paths distribution

  CALL gds.dag.longestPath.stream($dependencies_projection + '-cleaned')
 YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN toInteger(totalCost) AS distance
      ,count(*)             AS pathsCount
ORDER BY distance DESC