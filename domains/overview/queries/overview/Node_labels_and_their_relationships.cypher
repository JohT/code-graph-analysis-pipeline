// List node labels and their relationship types, their count and their density.

 MATCH (source)-[relation]->(target)
  WITH labels(source)       AS sourceLabels
      ,type  (relation)     AS relationshipType
      ,labels(target)       AS targetLabels
      ,count(*)             AS relationshipCount
UNWIND sourceLabels AS sourceLabel
  WITH *
 WHERE NOT sourceLabel STARTS WITH 'Mark4'
   AND NOT sourceLabel IN ['Type', 'Java', 'File', 'ByteCode']
  WITH collect(DISTINCT sourceLabel) AS sourceLabels
      ,relationshipType
      ,targetLabels
      ,relationshipCount
UNWIND targetLabels AS targetLabel
  WITH *
 WHERE NOT targetLabel STARTS WITH 'Mark4'
   AND NOT targetLabel IN ['Type', 'Java', 'File', 'ByteCode']
  WITH sourceLabels
      ,relationshipType
      ,collect(DISTINCT targetLabel) AS targetLabels
      ,relationshipCount
RETURN sourceLabels
      ,relationshipType
      ,targetLabels
      ,relationshipCount
ORDER BY relationshipCount DESC