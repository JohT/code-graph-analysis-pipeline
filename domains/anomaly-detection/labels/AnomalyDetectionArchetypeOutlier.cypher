// Anomaly Detection Query: Find code units of archetype "Outlier" by listing the (at most) top 20 entries with a normalized distance to the cluster medoid (center) >= 90% percentile and a clustering probability (1.0 - approximate cluster outlier score) <= 30% percentile. Requires tunedNodeEmbeddingClustering.py to be run first.
// Shows code that doesn't clearly fit into any architectural layer or domain boundary cleanly.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid IS NOT NULL
     AND codeUnit.clusteringHDBSCANProbability                IS NOT NULL
    WITH collect(codeUnit)                                                           AS codeUnits
        ,percentileDisc(codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid, 0.90)  AS distanceToMedoidThreshold
        ,percentileDisc(codeUnit.clusteringHDBSCANProbability, 0.30)                 AS clusteringProbabilityThreshold
  UNWIND codeUnits AS codeUnit
    WITH *
   WHERE codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid  >= distanceToMedoidThreshold
     AND codeUnit.clusteringHDBSCANProbability                 <= clusteringProbabilityThreshold
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
    WITH *, coalesce(artifactName, projectName)            AS projectName
   ORDER BY codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid DESC, codeUnit.clusteringHDBSCANProbability ASC
   LIMIT 10
    WITH collect([codeUnit, projectName]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
     SET codeUnit:Mark4TopAnomalyOutlier
        ,codeUnit.anomalyOutlierRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                        AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid AS clusteringNormalizedDistanceToMedoid
        ,1.0 - codeUnit.clusteringHDBSCANProbability          AS clusterApproximateOutlierScore
        ,codeUnit.anomalyOutlierRank                          AS rank