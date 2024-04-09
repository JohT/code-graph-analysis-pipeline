// Explore node properties, the labels of their nodes and their count

MATCH (n)
UNWIND keys(n)   AS nodePropertyName
UNWIND labels(n) AS nodeLabel
RETURN nodePropertyName
      ,collect(DISTINCT nodeLabel)   AS nodeLabels
      ,count(DISTINCT n)             AS numberOfNodes
      ,count(DISTINCT n[nodePropertyName])         AS numberOfDistinctValues
      ,collect(DISTINCT n[nodePropertyName])[0..4] AS exampleValues
ORDER BY nodePropertyName