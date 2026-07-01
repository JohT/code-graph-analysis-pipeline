// Anomaly Detection Query: Find over-referenced utility code by listing the (at most) top 20 entries with the highest Page Rank >= 90% percentile and a low local clustering coefficient below the 10% percentile.
// Shows code that is widely referenced, but loosely coupled in neighborhood — could be over-generalized or abused.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.centralityPageRank                  IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit) AS codeUnits
        ,percentileDisc(codeUnit.communityLocalClusteringCoefficient, 0.10) AS localClusteringCoefficientThreshold
        ,percentileDisc(codeUnit.centralityPageRank, 0.90)                  AS pageRankThreshold
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE codeUnit.communityLocalClusteringCoefficient <= localClusteringCoefficientThreshold
     AND codeUnit.centralityPageRank                  >= pageRankThreshold
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.projectName, '')           AS projectName
        ,codeUnit.communityLocalClusteringCoefficient AS localClusteringCoefficient
        ,codeUnit.centralityPageRank                  AS pageRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY pageRank DESC, localClusteringCoefficient ASC
  LIMIT 20