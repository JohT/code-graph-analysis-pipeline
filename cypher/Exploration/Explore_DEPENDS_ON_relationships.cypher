// Explore DEPENDS_ON relationships schema 

MATCH (s)-[r:DEPENDS_ON]->(t)
RETURN labels(s) AS sourceLabels
      ,labels(t) AS targetLabels
      ,keys(r)   AS relationshipKeys
      ,count(*)  AS numberOfNodes
ORDER BY sourceLabels, targetLabels, relationshipKeys