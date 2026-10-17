// Anomaly Detection Query: Find code units of archetype "Outlier" by listing the (at most) top 10 entries with a high normalized distance to the cluster medoid (center) and a low clustering probability (1.0 - approximate cluster outlier score) <= 30% percentile. Requires tunedNodeEmbeddingClustering.py to be run first.
// Shows code that doesn't clearly fit into any architectural layer or domain boundary cleanly.
// Method: Tukey Fence (IQR-based) for normalized distance to cluster medoid; probability filtering for additional validation.
// More robust than hard percentile thresholds; fence multiplier shown for transparency.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid IS NOT NULL
     AND codeUnit.clusteringHDBSCANProbability                IS NOT NULL
  // Get the quartiles for the normalized distance to cluster medoid
    WITH collect(codeUnit)                                                                        AS codeUnits
        ,percentileCont(codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid, 0.25)               AS distanceQuartile1
        ,percentileCont(codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid, 0.75)               AS distanceQuartile3
    WITH codeUnits
        ,distanceQuartile1
        ,distanceQuartile3
        ,(distanceQuartile3 - distanceQuartile1)                                                  AS distanceIQR
    WITH codeUnits
        ,distanceQuartile3
        ,distanceIQR
        ,(distanceQuartile3 + (0.7 * distanceIQR))                                                AS distanceFence
  // Get the threshold for the clustering probability (low probability = high outlier score)
  UNWIND codeUnits AS codeUnit
    WITH *
   WHERE codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid >= distanceFence
    WITH collect(codeUnit)                                                                        AS codeUnits
        ,distanceQuartile3
        ,distanceIQR
        ,distanceFence
        ,percentileDisc(codeUnit.clusteringHDBSCANProbability, 0.30)                             AS clusteringProbabilityThreshold
  // Unwind the code units to calculate the Tukey Fence strength for each individual code unit
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN distanceIQR > 0
              THEN (codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid - distanceQuartile3) / distanceIQR
              ELSE 0 END AS distanceTukeyFenceStrengthIQRs
        ,(codeUnit.clusteringHDBSCANProbability <= clusteringProbabilityThreshold) AS lowProbability
   WHERE codeUnit.clusteringHDBSCANProbability <= clusteringProbabilityThreshold
    WITH *
        ,CASE WHEN distanceTukeyFenceStrengthIQRs >= 1.5 AND lowProbability
               THEN 30
               WHEN distanceTukeyFenceStrengthIQRs >= 0.9 AND lowProbability
               THEN 20
               ELSE 10
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger >= 30
              THEN 'Strong outlier (distance >= 1.5 IQRs + low probability)'
              WHEN outlierClassInteger >= 20
              THEN 'Moderate outlier (distance >= 0.9 IQRs + low probability)'
              ELSE 'Light outlier (distance >= Tukey Fence + low probability)'
          END AS outlierClassification
    WITH *, coalesce(codeUnit.projectName, '') AS projectName
   ORDER BY outlierClassInteger DESC, codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid DESC, codeUnit.clusteringHDBSCANProbability ASC
   LIMIT 10
    WITH collect([codeUnit, projectName, outlierClassInteger, outlierClassification, distanceTukeyFenceStrengthIQRs, lowProbability, clusteringProbabilityThreshold]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
        ,results[codeUnitIndex][2]   AS outlierClassInteger
        ,results[codeUnitIndex][3]   AS outlierClassification
        ,results[codeUnitIndex][4]   AS distanceTukeyFenceStrengthIQRs
        ,results[codeUnitIndex][5]   AS lowProbability
        ,results[codeUnitIndex][6]   AS clusteringProbabilityThreshold
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
     SET codeUnit:Mark4TopAnomalyOutlier
        ,codeUnit.anomalyOutlierRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                        AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,outlierClassification
        ,codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid AS clusteringNormalizedDistanceToMedoid
        ,1.0 - codeUnit.clusteringHDBSCANProbability          AS clusterApproximateOutlierScore
        ,distanceTukeyFenceStrengthIQRs                       AS distanceTukeyFenceStrengthIQRs
        ,codeUnit.anomalyOutlierRank                          AS rank
        // Debug columns
        //,lowProbability                                      AS lowProbabilityDebug
        //,clusteringProbabilityThreshold                      AS clusteringProbabilityThresholdDebug
