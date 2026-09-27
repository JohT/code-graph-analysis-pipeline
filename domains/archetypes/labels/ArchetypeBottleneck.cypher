// Archetypes Labels: Label code units of archetype "Bottleneck" by looking for the top 10 entries with the highest Betweenness centrality. Requires features/*.cypher to be run first.
// Shows key code that is both heavily depended on and controls flow - critical hubs. Potentially an unintended dependency concentration: if removed, communication between modules breaks.
// Method: Tukey Fence (IQR-based outlier detection) - more robust than percentile thresholds on skewed distributions; bottleneck strength shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness IS NOT NULL
    WITH collect(codeUnit)                                                AS codeUnits
        ,percentileCont(codeUnit.centralityBetweenness, 0.25)             AS betweennessQuartile1
        ,percentileCont(codeUnit.centralityBetweenness, 0.75)             AS betweennessQuartile3
    WITH codeUnits
        ,betweennessQuartile1
        ,betweennessQuartile3
        ,(betweennessQuartile3 - betweennessQuartile1)                    AS betweennessIQR
    WITH codeUnits
        ,betweennessQuartile3
        ,betweennessIQR
        ,(betweennessQuartile3 + (0.7 * betweennessIQR))                  AS betweennessFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN betweennessIQR > 0
              THEN (codeUnit.centralityBetweenness - betweennessQuartile3) / betweennessIQR
              ELSE 0 END AS betweennessTukeyFenceStrengthIQRs
   WHERE codeUnit.centralityBetweenness >= betweennessFence
    WITH *
        ,CASE WHEN betweennessTukeyFenceStrengthIQRs >= 3.0
               THEN 30
               WHEN betweennessTukeyFenceStrengthIQRs >= 1.5
               THEN 20
               ELSE 10
          END AS outlierClassInteger
        ,CASE WHEN betweennessTukeyFenceStrengthIQRs >= 3.0
               THEN 'Strong bottleneck (>= 3.0 IQRs)'
               WHEN betweennessTukeyFenceStrengthIQRs >= 1.5
               THEN 'Moderate bottleneck (>= 1.5 IQRs)'
               ELSE 'Light bottleneck'
          END AS bottleneckClassification
    WITH *, coalesce(codeUnit.projectName, '') AS projectName
   ORDER BY outlierClassInteger DESC, codeUnit.centralityBetweenness DESC
   LIMIT 10
    WITH collect([codeUnit, projectName, outlierClassInteger, bottleneckClassification, betweennessTukeyFenceStrengthIQRs]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
        ,results[codeUnitIndex][2]   AS outlierClassInteger
        ,results[codeUnitIndex][3]   AS bottleneckClassification
        ,results[codeUnitIndex][4]   AS betweennessTukeyFenceStrengthIQRs
     SET codeUnit:Mark4TopArchetypeBottleneck
        ,codeUnit.archetypeBottleneckRank = codeUnitIndex
  RETURN projectName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,bottleneckClassification
        ,round(codeUnit.centralityBetweenness, 4)     AS betweenness
        ,round(betweennessTukeyFenceStrengthIQRs, 4)  AS betweennessTukeyFenceStrengthIQRs
        ,codeUnit.archetypeBottleneckRank             AS rank
        //,betweennessFence                             AS betweennessTukeyFenceDebug
  ORDER BY codeUnitIndex
