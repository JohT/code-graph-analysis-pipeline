// Node count for each label separate. Doesn_t sum up to the number of total labels since one node can have multiple labels.

 MATCH (allNodes)
  WITH COUNT(allNodes) AS totalNodeCount
 MATCH (nodesAndTheirLabels)
  WITH totalNodeCount
      ,labels(nodesAndTheirLabels) AS nodeLabels
      ,nodesAndTheirLabels
 UNWIND nodeLabels AS nodeLabel
  WITH totalNodeCount
      ,nodeLabel
      ,count(nodesAndTheirLabels)                                    AS nodesWithThatLabel
      ,toFloat(count(nodesAndTheirLabels)) / totalNodeCount * 100.0  AS nodesWithThatLabelPercent
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
RETURN nodeLabel, nodesWithThatLabel, nodesWithThatLabelPercent
ORDER BY nodesWithThatLabel DESC, nodeLabel ASC