// Explore node labels and their relationships for a schema overview

 MATCH (allNodes)
  WITH COUNT(allNodes)              AS totalNodeCount
MATCH (source)-[link]->(target)
WITH  totalNodeCount 
     ,labels(source)                AS sourceLabels
     ,labels(target)                AS targetLabels
     ,collect(DISTINCT type(link))  AS relationshipTypes
     ,count(*)                      AS numberOfNodes
UNWIND sourceLabels AS sourceLabel
 WITH *
 WHERE NOT sourceLabel STARTS WITH 'Mark4'
 WITH totalNodeCount
     ,collect(DISTINCT sourceLabel) AS sourceLabels
     ,targetLabels
     ,relationshipTypes
     ,numberOfNodes
UNWIND targetLabels AS targetLabel
 WITH *
 WHERE NOT targetLabel STARTS WITH 'Mark4'
 WITH totalNodeCount
     ,sourceLabels
     ,collect(DISTINCT targetLabel) AS targetLabels
     ,relationshipTypes
     ,numberOfNodes
RETURN apoc.text.join(sourceLabels, ',')      AS sourceLabels
      ,apoc.text.join(relationshipTypes, ',') AS relationshipTypes
      ,apoc.text.join(targetLabels, ',')      AS targetLabels
      ,numberOfNodes
      ,round(toFloat(numberOfNodes) / totalNodeCount * 100.0, 2) AS percentageOfTotalNodes
ORDER BY numberOfNodes DESC
LIMIT 200