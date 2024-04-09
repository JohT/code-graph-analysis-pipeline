// Get all relationships of one specific node to explore the schema 

MATCH (s:TS:Module)-[r]->(t)
RETURN labels(s) AS sourceLabels
      ,keys(s)   AS sourceKeys
      ,labels(t) AS targetLabels
      ,keys(t)   AS targetKeys
      ,type(r)   AS relationshipType
      ,keys(r)   AS relationshipKeys
      ,count(*)  AS numberOfNodes
ORDER BY sourceLabels, targetLabels, relationshipKeys