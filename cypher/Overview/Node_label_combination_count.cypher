// Node count for each label combination. Sums up to the total number of nodes.

 MATCH (allNodes)
  WITH COUNT(allNodes) AS totalNodeCount
 MATCH (nodesAndTheirLabels)
  WITH totalNodeCount
      ,labels(nodesAndTheirLabels) AS nodeLabels
      ,nodesAndTheirLabels
 UNWIND nodeLabels AS nodeLabel
  WITH totalNodeCount
      ,nodeLabel
      ,nodesAndTheirLabels
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
  WITH totalNodeCount
      ,collect(nodeLabel)             AS nodeLabels
      ,nodesAndTheirLabels
  WITH totalNodeCount
      ,nodeLabels
      ,count(nodesAndTheirLabels)     AS nodesWithThatLabels
      ,toFloat(count(nodesAndTheirLabels)) / totalNodeCount * 100.0  AS nodesWithThatLabelsPercent
RETURN nodeLabels, nodesWithThatLabels, nodesWithThatLabelsPercent
ORDER BY nodesWithThatLabels DESC