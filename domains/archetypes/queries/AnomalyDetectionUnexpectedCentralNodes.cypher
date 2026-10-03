// Anomaly Detection Query: Find hidden bottlenecks or hubs using Tukey Fence for betweenness (IQR-based outlier detection) and a degree below the 10% percentile.
// Shows code with high structural importance and only a few incoming and outgoing dependencies - often unexpected.
// Betweenness uses IQR-based outlier detection; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.testMarkerInteger = 0
     AND codeUnit.centralityBetweenness   IS NOT NULL
     AND codeUnit.incomingDependencies    IS NOT NULL
     AND codeUnit.outgoingDependencies    IS NOT NULL
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
    WITH collect(codeUnit)                                     AS codeUnits
        ,percentileDisc(degree, 0.40)                          AS degreeThreshold
        ,percentileCont(codeUnit.centralityBetweenness, 0.25)  AS betweennessQuartile1
        ,percentileCont(codeUnit.centralityBetweenness, 0.75)  AS betweennessQuartile3
    WITH codeUnits
        ,degreeThreshold
        ,betweennessQuartile1
        ,betweennessQuartile3
        ,(betweennessQuartile3 - betweennessQuartile1)         AS betweennessIQR
    WITH codeUnits
        ,degreeThreshold
        ,betweennessQuartile3
        ,betweennessIQR
        ,(betweennessQuartile3 + (0.7 * betweennessIQR))       AS betweennessFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies  AS degree
        ,CASE WHEN betweennessIQR > 0 
              THEN (codeUnit.centralityBetweenness - betweennessQuartile3) / betweennessIQR 
              ELSE 0 END AS betweennessTukeyFenceStrengthIQRs
   WHERE degree                         <= degreeThreshold
     AND codeUnit.centralityBetweenness >= betweennessFence
    WITH *
        ,CASE WHEN betweennessTukeyFenceStrengthIQRs >= 1.5 THEN 30
              WHEN betweennessTukeyFenceStrengthIQRs >= 0.9 THEN 20
              ELSE 10 
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger = 30 THEN 'Strong outlier (betweenness ≥ 1.5 IQRs)'
              WHEN outlierClassInteger = 20 THEN 'Moderate outlier (betweenness ≥ 0.9 IQRs)'
              ELSE 'Light outlier'
          END AS outlierClassification
  RETURN coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.projectName, '')           AS projectName
        ,outlierClassification
        ,codeUnit.centralityBetweenness               AS betweenness
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
        ,betweennessTukeyFenceStrengthIQRs            AS betweennessTukeyFenceStrengthIQRs
        // Debug: uncomment below to troubleshoot fence thresholds
        //,betweennessFence                             AS betweennessTukeyFenceDebug
  ORDER BY outlierClassInteger DESC, degree ASC, betweenness DESC
  LIMIT 20