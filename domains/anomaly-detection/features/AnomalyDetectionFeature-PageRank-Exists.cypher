// Return the first node with a centralityPageRank if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRank         IS NOT NULL
  RETURN codeUnit.name                       AS shortCodeUnitName
        ,elementId(codeUnit)                 AS nodeElementId
        ,codeUnit.centralityPageRank         AS pageRank
   LIMIT 1