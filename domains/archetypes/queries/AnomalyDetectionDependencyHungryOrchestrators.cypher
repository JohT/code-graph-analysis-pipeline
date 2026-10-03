// Anomaly Detection Query: Find dependency hungry orchestrators using Tukey Fence (Interquartile Range(IQR)-based outlier detection).
// Shows key code that depend on many others and also controls flow - likely orchestrators or managers.
// More robust than percentile thresholds on skewed distributions; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.testMarkerInteger = 0
     AND codeUnit.centralityBetweenness   IS NOT NULL
     AND codeUnit.centralityArticleRank   IS NOT NULL
     AND codeUnit.incomingDependencies    IS NOT NULL
     AND codeUnit.outgoingDependencies    IS NOT NULL
    WITH collect(codeUnit)                                     AS codeUnits
        ,percentileCont(codeUnit.centralityBetweenness, 0.25)  AS betweennessQuartile1
        ,percentileCont(codeUnit.centralityBetweenness, 0.75)  AS betweennessQuartile3
        ,percentileCont(codeUnit.centralityArticleRank, 0.25)  AS articleRankQuartile1
        ,percentileCont(codeUnit.centralityArticleRank, 0.75)  AS articleRankQuartile3
    WITH codeUnits
        ,betweennessQuartile1
        ,betweennessQuartile3
        ,(betweennessQuartile3 - betweennessQuartile1)         AS betweennessIQR
        ,articleRankQuartile1
        ,articleRankQuartile3
        ,(articleRankQuartile3 - articleRankQuartile1)         AS articleRankIQR
    WITH codeUnits
        ,betweennessQuartile3
        ,betweennessIQR
        ,articleRankQuartile3
        ,articleRankIQR
        ,(betweennessQuartile3 + (0.7 * betweennessIQR))       AS betweennessFence
        ,(articleRankQuartile3 + (0.7 * articleRankIQR))       AS articleRankFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN betweennessIQR > 0 
              THEN (codeUnit.centralityBetweenness - betweennessQuartile3) / betweennessIQR 
              ELSE 0 END AS betweennessTukeyFenceStrengthIQRs
        ,CASE WHEN articleRankIQR > 0 
              THEN (codeUnit.centralityArticleRank - articleRankQuartile3) / articleRankIQR 
              ELSE 0 END AS articleRankTukeyFenceStrengthIQRs
   WHERE codeUnit.centralityBetweenness >= betweennessFence
     AND codeUnit.centralityArticleRank >= articleRankFence
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies  AS degree
        ,CASE WHEN betweennessTukeyFenceStrengthIQRs >= 1.5 
               AND articleRankTukeyFenceStrengthIQRs >= 1.5 
              THEN 30
              WHEN betweennessTukeyFenceStrengthIQRs >= 0.9 
               AND articleRankTukeyFenceStrengthIQRs >= 0.9
              THEN 20
              ELSE 10 
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger = 30 THEN 'Strong outlier (both ≥ 1.5 IQRs)'
              WHEN outlierClassInteger = 20 THEN 'Moderate outlier (both ≥ 0.9 IQRs)'
              ELSE 'Light outlier'
          END AS outlierClassification
  RETURN coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.projectName, '')           AS projectName
        ,outlierClassification
        ,codeUnit.centralityBetweenness               AS betweenness
        ,codeUnit.centralityArticleRank               AS articleRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
        ,betweennessTukeyFenceStrengthIQRs            AS betweennessTukeyFenceStrengthIQRs
        ,articleRankTukeyFenceStrengthIQRs            AS articleRankTukeyFenceStrengthIQRs
        // Debug: uncomment below to troubleshoot fence thresholds
        //,betweennessFence                             AS betweennessTukeyFenceDebug
        //,articleRankFence                             AS articleRankTukeyFenceDebug
  ORDER BY outlierClassInteger DESC, articleRank DESC, betweenness DESC
  LIMIT 20