// Anomaly Detection Query: Find popular bottlenecks using Tukey Fence (Interquartile Range(IQR)-based outlier detection).
// Shows key code that is both heavily depended on and controls flow - critical hubs.
// More robust than percentile thresholds on skewed distributions; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.testMarkerInteger = 0
     AND codeUnit.centralityBetweenness   IS NOT NULL
     AND codeUnit.centralityPageRank      IS NOT NULL
     AND codeUnit.incomingDependencies    IS NOT NULL
     AND codeUnit.outgoingDependencies    IS NOT NULL
    WITH collect(codeUnit)                                     AS codeUnits
        ,percentileCont(codeUnit.centralityBetweenness, 0.25)  AS betweennessQuartile1
        ,percentileCont(codeUnit.centralityBetweenness, 0.75)  AS betweennessQuartile3
        ,percentileCont(codeUnit.centralityPageRank, 0.25)     AS pageRankQuartile1
        ,percentileCont(codeUnit.centralityPageRank, 0.75)     AS pageRankQuartile3
    WITH codeUnits
        ,betweennessQuartile1
        ,betweennessQuartile3
        ,(betweennessQuartile3 - betweennessQuartile1)         AS betweennessIQR
        ,pageRankQuartile1
        ,pageRankQuartile3
        ,(pageRankQuartile3 - pageRankQuartile1)               AS pageRankIQR
    WITH codeUnits
        ,betweennessQuartile3
        ,betweennessIQR
        ,pageRankQuartile3
        ,pageRankIQR
        ,(betweennessQuartile3 + (0.7 * betweennessIQR))       AS betweennessFence
        ,(pageRankQuartile3 + (0.7 * pageRankIQR))             AS pageRankFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN betweennessIQR > 0 
              THEN (codeUnit.centralityBetweenness - betweennessQuartile3) / betweennessIQR 
              ELSE 0 END AS betweennessTukeyFenceStrengthIQRs
        ,CASE WHEN pageRankIQR > 0 
              THEN (codeUnit.centralityPageRank - pageRankQuartile3) / pageRankIQR 
              ELSE 0 END AS pageRankTukeyFenceStrengthIQRs
   WHERE codeUnit.centralityBetweenness >= betweennessFence
     AND codeUnit.centralityPageRank    >= pageRankFence
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies  AS degree
        ,CASE WHEN betweennessTukeyFenceStrengthIQRs >= 1.5 
               AND pageRankTukeyFenceStrengthIQRs >= 1.5 
              THEN 30
              WHEN betweennessTukeyFenceStrengthIQRs >= 0.9 
               AND pageRankTukeyFenceStrengthIQRs >= 0.9
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
        ,codeUnit.centralityPageRank                  AS pageRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
        ,betweennessTukeyFenceStrengthIQRs            AS betweennessTukeyFenceStrengthIQRs
        ,pageRankTukeyFenceStrengthIQRs               AS pageRankTukeyFenceStrengthIQRs
        // Debug: uncomment below to troubleshoot fence thresholds
        //,betweennessFence                             AS betweennessTukeyFenceDebug
        //,pageRankFence                                AS pageRankTukeyFenceDebug
  ORDER BY outlierClassInteger DESC, pageRank DESC, betweenness DESC
  LIMIT 20