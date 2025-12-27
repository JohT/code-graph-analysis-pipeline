// List top anomalies

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.anomalyScore > 0
     AND codeUnit.anomalyLabel = 1
   ORDER BY codeUnit.anomalyScore DESC
   LIMIT 50
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
    WITH *, coalesce(artifactName, projectName)            AS projectName
  RETURN projectName
        ,codeUnit.name                                     AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.anomalyRank                              AS anomalyRank
        ,codeUnit.anomalyScore                             AS anomalyScore
        ,coalesce(codeUnit.anomalyAuthorityRank, 0)        AS authorityRank
        ,coalesce(codeUnit.anomalyBottleneckRank, 0)       AS bottleneckRank
        ,coalesce(codeUnit.anomalyBridgeRank, 0)           AS bridgeRank
        ,coalesce(codeUnit.anomalyHubRank, 0)              AS hubRank
        ,coalesce(codeUnit.anomalyOutlierRank, 0)          AS outlierRank
        ,coalesce(codeUnit.dependencyDegreeRank, 0)        AS degreeRank
        ,codeUnit.anomalyTopFeature1                       AS topFeature1
        ,codeUnit.anomalyTopFeature2                       AS topFeature2
        ,codeUnit.anomalyTopFeature3                       AS topFeature3
        ,codeUnit.anomalyTopFeatureSHAPValue1              AS topFeature1Score
        ,codeUnit.anomalyTopFeatureSHAPValue2              AS topFeature2Score
        ,codeUnit.anomalyTopFeatureSHAPValue3              AS topFeature3Score
