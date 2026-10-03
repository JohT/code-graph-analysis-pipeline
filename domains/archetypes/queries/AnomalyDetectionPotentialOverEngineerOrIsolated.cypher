// Anomaly Detection Query: Find potential over-engineered or isolated code units using Tukey Fence for local clustering coefficient (IQR-based outlier detection) and a Page Rank below the 10% percentile.
// Shows tightly internally coupled code that is rarely depended on from outside - may signal over-engineering or isolation.
// Local clustering coefficient uses IQR-based outlier detection; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.testMarkerInteger = 0
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.centralityPageRank                  IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                        AS codeUnits
        ,percentileCont(codeUnit.communityLocalClusteringCoefficient, 0.25)      AS localClusteringCoefficientQuartile1
        ,percentileCont(codeUnit.communityLocalClusteringCoefficient, 0.75)      AS localClusteringCoefficientQuartile3
        ,percentileDisc(codeUnit.centralityPageRank, 0.10)                       AS pageRankThreshold
    WITH codeUnits
        ,localClusteringCoefficientQuartile1
        ,localClusteringCoefficientQuartile3
        ,(localClusteringCoefficientQuartile3 - localClusteringCoefficientQuartile1) AS localClusteringCoefficientIQR
        ,pageRankThreshold
    WITH codeUnits
        ,localClusteringCoefficientQuartile3
        ,localClusteringCoefficientIQR
        ,pageRankThreshold
        ,(localClusteringCoefficientQuartile3 + (0.7 * localClusteringCoefficientIQR)) AS localClusteringCoefficientFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN localClusteringCoefficientIQR > 0 
              THEN (codeUnit.communityLocalClusteringCoefficient - localClusteringCoefficientQuartile3) / localClusteringCoefficientIQR 
              ELSE 0 END AS localClusteringCoefficientTukeyFenceStrengthIQRs
   WHERE codeUnit.centralityPageRank                  <= pageRankThreshold
     AND codeUnit.communityLocalClusteringCoefficient >= localClusteringCoefficientFence
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies           AS degree
        ,CASE WHEN localClusteringCoefficientTukeyFenceStrengthIQRs >= 1.5 THEN 30
              WHEN localClusteringCoefficientTukeyFenceStrengthIQRs >= 0.9 THEN 20
              ELSE 10 
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger = 30 THEN 'Strong outlier (clustering ≥ 1.5 IQRs)'
              WHEN outlierClassInteger = 20 THEN 'Moderate outlier (clustering ≥ 0.9 IQRs)'
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
        ,localClusteringCoefficientTukeyFenceStrengthIQRs AS localClusteringCoefficientTukeyFenceStrengthIQRs
        // Debug: uncomment below to troubleshoot fence thresholds
        //,localClusteringCoefficientFence               AS localClusteringCoefficientTukeyFenceDebug
  ORDER BY outlierClassInteger DESC, localClusteringCoefficient DESC, pageRank ASC
  LIMIT 20