// Return the first node with (amongst others) a "centralityPageRankToArticleRankDifference" property if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRankToArticleRankDifference IS NOT NULL
     AND codeUnit.centralityPageRankNormalized              IS NOT NULL
     AND codeUnit.centralityArticleRankNormalized           IS NOT NULL
  RETURN codeUnit.name                                      AS shortCodeUnitName
        ,elementId(codeUnit)                                AS nodeElementId
        ,codeUnit.centralityPageRankToArticleRankDifference AS pageToArticleRankDifference
   LIMIT 1