// Calculates and writes the (amongst others) "centralityPageRankToArticleRankDifference" property.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRank    IS NOT NULL
     AND codeUnit.centralityArticleRank IS NOT NULL
    WITH collect(codeUnit)                                 AS codeUnits
        ,min(codeUnit.centralityPageRank)                  AS minPageRank
        ,max(codeUnit.centralityPageRank)                  AS maxPageRank
        ,min(codeUnit.centralityArticleRank)               AS minArticleRank
        ,max(codeUnit.centralityArticleRank)               AS maxArticleRank
  UNWIND codeUnits AS codeUnit
    WITH *
        ,(codeUnit.centralityPageRank - minPageRank) / (maxPageRank - minPageRank)             AS normalizedPageRank
        ,(codeUnit.centralityArticleRank - minArticleRank) / (maxArticleRank - minArticleRank) AS normalizedArticleRank
   WITH *
       ,normalizedPageRank - normalizedArticleRank         AS normalizedPageRankToArticleRankDifference
    SET codeUnit.centralityPageRankToArticleRankDifference =  normalizedPageRankToArticleRankDifference
       ,codeUnit.centralityPageRankNormalized              =  normalizedPageRank
       ,codeUnit.centralityArticleRankNormalized           =  normalizedArticleRank
RETURN count(*) AS nodePropertiesWritten