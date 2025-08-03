// Query code unit nodes with their anomaly detection

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit[$community_property]                        IS NOT NULL
     AND codeUnit.incomingDependencies                        IS NOT NULL
     AND codeUnit.outgoingDependencies                        IS NOT NULL
     AND codeUnit.communityLocalClusteringCoefficient         IS NOT NULL
     AND codeUnit.centralityArticleRank                       IS NOT NULL
     AND codeUnit.centralityPageRank                          IS NOT NULL
     AND codeUnit.centralityBetweenness                       IS NOT NULL
     AND codeUnit.clusteringHDBSCANLabel                      IS NOT NULL
     AND codeUnit.clusteringHDBSCANProbability                IS NOT NULL
     AND codeUnit.clusteringHDBSCANNoise                      IS NOT NULL
     AND codeUnit.clusteringHDBSCANMedoid                     IS NOT NULL
     AND codeUnit.clusteringHDBSCANSize                       IS NOT NULL
     AND codeUnit.clusteringHDBSCANRadiusMax                  IS NOT NULL
     AND codeUnit.clusteringHDBSCANRadiusAverage              IS NOT NULL
     AND codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid IS NOT NULL
// The following columns can be null if there is not enough data or an error in the anomaly detection pipeline
//     AND codeUnit.anomalyLabel                                IS NOT NULL
//     AND codeUnit.anomalyScore                                IS NOT NULL
//     AND codeUnit.anomalyTopFeature1                          IS NOT NULL
//     AND codeUnit.anomalyTopFeature2                          IS NOT NULL
//     AND codeUnit.anomalyTopFeature3                          IS NOT NULL
//     AND codeUnit.anomalyTopFeatureSHAPValue1                 IS NOT NULL
//     AND codeUnit.anomalyTopFeatureSHAPValue2                 IS NOT NULL
//     AND codeUnit.anomalyTopFeatureSHAPValue3                 IS NOT NULL
     AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX IS NOT NULL
     AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY IS NOT NULL
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                        AS shortCodeUnitName
        ,elementId(codeUnit)                                  AS nodeElementId
        ,coalesce(artifactName, projectName, "")              AS projectName
        ,codeUnit.incomingDependencies                        AS incomingDependencies
        ,codeUnit.outgoingDependencies                        AS outgoingDependencies
        ,codeUnit[$community_property]                        AS communityId
        ,codeUnit.communityLocalClusteringCoefficient         AS clusteringCoefficient
        ,codeUnit.centralityArticleRank                       AS articleRank
        ,codeUnit.centralityPageRank                          AS pageRank
        ,codeUnit.centralityPageRank - codeUnit.centralityArticleRank AS pageToArticleRankDifference
        ,codeUnit.centralityBetweenness                       AS betweenness
        ,codeUnit.clusteringHDBSCANLabel                      AS clusteringLabel
        ,codeUnit.clusteringHDBSCANProbability                AS clusteringProbability
        ,codeUnit.clusteringHDBSCANNoise                      AS clusteringIsNoise
        ,codeUnit.clusteringHDBSCANMedoid                     AS clusteringIsMedoid
        ,codeUnit.clusteringHDBSCANSize                       AS clusteringSize
        ,codeUnit.clusteringHDBSCANRadiusMax                  AS clusteringRadiusMax
        ,codeUnit.clusteringHDBSCANRadiusAverage              AS clusteringRadiusAverage
        ,codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid AS clusteringNormalizedDistanceToMedoid
        ,codeUnit.anomalyLabel                                AS anomalyLabel
        ,codeUnit.anomalyScore                                AS anomalyScore
        ,codeUnit.anomalyTopFeature1                          AS anomalyTopFeature1
        ,codeUnit.anomalyTopFeature2                          AS anomalyTopFeature2
        ,codeUnit.anomalyTopFeature3                          AS anomalyTopFeature3
        ,codeUnit.anomalyTopFeatureSHAPValue1                 AS anomalyTopFeatureSHAPValue1
        ,codeUnit.anomalyTopFeatureSHAPValue2                 AS anomalyTopFeatureSHAPValue2
        ,codeUnit.anomalyTopFeatureSHAPValue3                 AS anomalyTopFeatureSHAPValue3
        ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX AS visualizationX
        ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY AS visualizationY
