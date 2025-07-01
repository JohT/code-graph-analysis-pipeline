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
        ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX AS visualizationX
        ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY AS visualizationY
