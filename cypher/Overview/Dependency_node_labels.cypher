// Explore DEPENDS_ON relationship node labels 

 MATCH (allNodes)
  WITH COUNT(allNodes) AS totalNodeCount
MATCH (source)-[:DEPENDS_ON]->(target)
WITH  totalNodeCount 
     ,labels(source)   AS sourceLabels
     ,labels(target)   AS targetLabels
     ,count(*)         AS numberOfNodes
UNWIND sourceLabels AS sourceLabel
 WITH *
 WHERE NOT sourceLabel STARTS WITH 'Mark4'
 WITH totalNodeCount
     ,collect(DISTINCT sourceLabel) AS sourceLabels
     ,targetLabels
     ,numberOfNodes
UNWIND targetLabels AS targetLabel
 WITH *
 WHERE NOT targetLabel STARTS WITH 'Mark4'
 WITH totalNodeCount
     ,sourceLabels
     ,collect(DISTINCT targetLabel) AS targetLabels
     ,numberOfNodes
RETURN apoc.text.join(sourceLabels, ',') AS sourceLabels
      ,apoc.text.join(targetLabels, ',') AS targetLabels
      ,numberOfNodes
      ,round(toFloat(numberOfNodes) / totalNodeCount * 100.0, 2) AS percentageOfTotalNodes
ORDER BY numberOfNodes DESC, sourceLabels, targetLabels