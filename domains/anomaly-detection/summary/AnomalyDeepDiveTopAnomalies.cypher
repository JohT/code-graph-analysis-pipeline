// Anomaly Detection Summary: Lists top anomalies (at most 20), the top 3 features that contributed to the decision and the archetype(s) classification (if available) they are assigned to. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

 MATCH (codeUnit)
 WHERE $projection_node_label IN labels(codeUnit)
   AND codeUnit.anomalyScore > 0
ORDER BY codeUnit.anomalyScore DESC
UNWIND keys(codeUnit) AS codeUnitProperty
  WITH codeUnit
      ,CASE WHEN codeUnitProperty STARTS WITH 'anomaly'  
             AND codeUnitProperty ENDS   WITH 'Rank'
            THEN split(split(codeUnitProperty, 'anomaly')[1], 'Rank')[0]
        END AS archetype
      ,CASE WHEN codeUnitProperty STARTS WITH 'anomaly'  
             AND codeUnitProperty ENDS   WITH 'Rank'
            THEN codeUnit[codeUnitProperty]
        END AS archetypeRank
ORDER BY codeUnit.anomalyScore DESC, archetypeRank ASC
  WITH codeUnit
      ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
      ,apoc.text.join(collect(DISTINCT archetype), ', ') AS archetypes
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name                                             AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/'))            AS projectName
OPTIONAL MATCH (codeDirectory:File:Directory)-[:CONTAINS]->(codeUnit)
    WITH *, split(replace(codeDirectory.fileName, './', ''), '/')[-2] AS directoryName
    WITH *, coalesce(artifactName, projectName, directoryName, "")    AS projectName
RETURN codeUnitName                                                           AS `Name`
      ,projectName                                                            AS `Contained in`
      ,round(codeUnit.anomalyScore, 4, 'HALF_UP')                             AS `Anomaly Score`
      ,collect(archetypes)[0]                                                 AS `Archetypes`
      ,nullif(codeUnit.anomalyTopFeature1, "")                                AS `Top Feature 1`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue1, 4, 'HALF_UP'), 0.0) AS `Top Feature 1 SHAP`
      ,nullif(codeUnit.anomalyTopFeature2, "")                                AS `Top Feature 2`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue2, 4, 'HALF_UP'), 0.0) AS `Top Feature 2 SHAP`
      ,nullif(codeUnit.anomalyTopFeature3, "")                                AS `Top Feature 3`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue3, 4, 'HALF_UP'), 0.0) AS `Top Feature 3 SHAP`
      ,CASE WHEN codeUnit.anomalyScore <= 0          THEN 'Typical'
            WHEN codeUnit.anomalyTopFeature1 IS NULL THEN 'Undetermined'
                                                     ELSE 'Anomalous'     END AS `Model Status`
LIMIT 20