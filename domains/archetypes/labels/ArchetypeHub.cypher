// Archetypes Labels: Label code units of archetype "Hub" by looking for the (at most) top 10 entries with the highest degree and a local clustering coefficient at the low end. Requires features/*.cypher to be run first.
// Shows code with many connections that are not well integrated into a cluster.
// Method: Tukey Fence (IQR-based) for degree (high end) and inverted for clustering coefficient (low end) - identifies peripheral connector nodes.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                                   AS codeUnits
        ,percentileCont(codeUnit.incomingDependencies + codeUnit.outgoingDependencies, 0.25) AS degreeQuartile1
        ,percentileCont(codeUnit.incomingDependencies + codeUnit.outgoingDependencies, 0.75) AS degreeQuartile3
        ,percentileCont(codeUnit.communityLocalClusteringCoefficient, 0.25)                  AS clusteringCoefficientQuartile1
        ,percentileCont(codeUnit.communityLocalClusteringCoefficient, 0.75)                  AS clusteringCoefficientQuartile3
    WITH codeUnits
        ,degreeQuartile1
        ,degreeQuartile3
        ,(degreeQuartile3 - degreeQuartile1)                                                 AS degreeIQR
        ,clusteringCoefficientQuartile1
        ,clusteringCoefficientQuartile3
        ,(clusteringCoefficientQuartile3 - clusteringCoefficientQuartile1)                   AS clusteringCoefficientIQR
    WITH codeUnits
        ,degreeQuartile3
        ,degreeIQR
        ,clusteringCoefficientQuartile1
        ,clusteringCoefficientIQR
        ,(degreeQuartile3 + (0.7 * degreeIQR))                                               AS degreeFence
        ,(clusteringCoefficientQuartile1 - (0.7 * clusteringCoefficientIQR))                 AS clusteringCoefficientLowerFence
  UNWIND codeUnits AS codeUnit
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
    WITH *
        ,CASE WHEN degreeIQR > 0
              THEN (degree - degreeQuartile3) / degreeIQR
              ELSE 0 END AS degreeTukeyFenceStrengthIQRs
        ,CASE WHEN clusteringCoefficientIQR > 0
              THEN (clusteringCoefficientQuartile1 - codeUnit.communityLocalClusteringCoefficient) / clusteringCoefficientIQR
              ELSE 0 END AS clusteringCoefficientTukeyLowerFenceStrengthIQRs
   WHERE degree                                       >= degreeFence
     AND codeUnit.communityLocalClusteringCoefficient <= clusteringCoefficientLowerFence
    WITH *
        ,CASE WHEN degreeTukeyFenceStrengthIQRs >= 1.5 AND clusteringCoefficientTukeyLowerFenceStrengthIQRs >= 1.5
               THEN 30
               WHEN degreeTukeyFenceStrengthIQRs >= 0.9 AND clusteringCoefficientTukeyLowerFenceStrengthIQRs >= 0.9
               THEN 20
               ELSE 10
          END AS outlierClassInteger
        ,CASE WHEN degreeTukeyFenceStrengthIQRs >= 1.5 AND clusteringCoefficientTukeyLowerFenceStrengthIQRs >= 1.5
               THEN 'Strong hub (both >= 1.5 IQRs)'
               WHEN degreeTukeyFenceStrengthIQRs >= 0.9 AND clusteringCoefficientTukeyLowerFenceStrengthIQRs >= 0.9
               THEN 'Moderate hub (both >= 0.9 IQRs)'
               ELSE 'Light hub'
          END AS hubClassification
    WITH *, coalesce(codeUnit.projectName, '') AS projectName
   ORDER BY outlierClassInteger DESC, codeUnit.communityLocalClusteringCoefficient ASC, degree DESC
   LIMIT 10
    WITH collect([codeUnit, projectName, outlierClassInteger, hubClassification, degreeTukeyFenceStrengthIQRs, clusteringCoefficientTukeyLowerFenceStrengthIQRs, degree]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
        ,results[codeUnitIndex][2]   AS outlierClassInteger
        ,results[codeUnitIndex][3]   AS hubClassification
        ,results[codeUnitIndex][4]   AS degreeTukeyFenceStrengthIQRs
        ,results[codeUnitIndex][5]   AS clusteringCoefficientTukeyLowerFenceStrengthIQRs
        ,results[codeUnitIndex][6]   AS degree
     SET codeUnit:Mark4TopArchetypeHub
        ,codeUnit.archetypeHubRank = codeUnitIndex
  RETURN projectName
        ,codeUnit.name                                              AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,hubClassification
        ,round(codeUnit.communityLocalClusteringCoefficient, 6)     AS localClusteringCoefficient
        ,degree
        ,codeUnit.incomingDependencies                              AS incomingDependencies
        ,codeUnit.outgoingDependencies                              AS outgoingDependencies
        ,round(degreeTukeyFenceStrengthIQRs, 4)                     AS degreeTukeyFenceStrengthIQRs
        ,round(clusteringCoefficientTukeyLowerFenceStrengthIQRs, 4) AS clusteringCoefficientTukeyLowerFenceStrengthIQRs
        ,codeUnit.archetypeHubRank                                  AS rank
        //,degreeFence                                              AS degreeTukeyFenceDebug
        //,clusteringCoefficientLowerFence                      AS clusteringCoefficientTukeyLowerFenceDebug
  ORDER BY codeUnitIndex
