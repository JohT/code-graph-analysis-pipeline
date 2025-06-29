// Return the first node with a centralityBetweenness if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness      IS NOT NULL
  RETURN codeUnit.name                       AS shortCodeUnitName
        ,elementId(codeUnit)                 AS nodeElementId
        ,codeUnit.centralityBetweenness      AS pageRank
   LIMIT 1