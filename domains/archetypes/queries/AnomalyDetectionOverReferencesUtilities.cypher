// Anomaly Detection Query: Find over-referenced utility code using Tukey Fence for Page Rank (IQR-based outlier detection) and a local clustering coefficient below the 10% percentile.
// Shows code that is widely referenced, but loosely coupled in neighborhood - could be over-generalized or abused.
// Page Rank uses IQR-based outlier detection; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.testMarkerInteger = 0
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.centralityPageRank                  IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                   AS codeUnits
        ,percentileCont(codeUnit.centralityPageRank, 0.25)                  AS pageRankQuartile1
        ,percentileCont(codeUnit.centralityPageRank, 0.75)                  AS pageRankQuartile3
        ,percentileDisc(codeUnit.communityLocalClusteringCoefficient, 0.10) AS localClusteringCoefficientThreshold
    WITH codeUnits
        ,pageRankQuartile1
        ,pageRankQuartile3
        ,(pageRankQuartile3 - pageRankQuartile1)                            AS pageRankIQR
        ,localClusteringCoefficientThreshold
    WITH codeUnits
        ,pageRankQuartile3
        ,pageRankIQR
        ,localClusteringCoefficientThreshold
        ,(pageRankQuartile3 + (0.7 * pageRankIQR))                          AS pageRankFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN pageRankIQR > 0 
              THEN (codeUnit.centralityPageRank - pageRankQuartile3) / pageRankIQR 
              ELSE 0 END AS pageRankTukeyFenceStrengthIQRs
   WHERE codeUnit.communityLocalClusteringCoefficient <= localClusteringCoefficientThreshold
     AND codeUnit.centralityPageRank                  >= pageRankFence
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies      AS degree
        ,CASE WHEN pageRankTukeyFenceStrengthIQRs >= 1.5 THEN 30
              WHEN pageRankTukeyFenceStrengthIQRs >= 0.9 THEN 20
              ELSE 10 
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger = 30 THEN 'Strong outlier (pageRank ≥ 1.5 IQRs)'
              WHEN outlierClassInteger = 20 THEN 'Moderate outlier (pageRank ≥ 0.9 IQRs)'
              ELSE 'Light outlier'
          END AS outlierClassification
  RETURN coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.projectName, '')           AS projectName
        ,outlierClassification
        ,codeUnit.communityLocalClusteringCoefficient AS localClusteringCoefficient
        ,codeUnit.centralityPageRank                  AS pageRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
        ,pageRankTukeyFenceStrengthIQRs               AS pageRankTukeyFenceStrengthIQRs
        // Debug: uncomment below to troubleshoot fence thresholds
        //,pageRankFence                                AS pageRankTukeyFenceDebug
  ORDER BY outlierClassInteger DESC, pageRank DESC, localClusteringCoefficient ASC
  LIMIT 20