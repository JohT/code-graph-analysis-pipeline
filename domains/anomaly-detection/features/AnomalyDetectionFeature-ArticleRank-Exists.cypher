// Return the first node with a centralityArticleRank if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityArticleRank      IS NOT NULL
  RETURN codeUnit.name                       AS shortCodeUnitName
        ,elementId(codeUnit)                 AS nodeElementId
        ,codeUnit.centralityArticleRank      AS articleRank
   LIMIT 1