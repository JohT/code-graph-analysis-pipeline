// Anomaly Detection Labels: Summarizes all labelled archetypes by their anomaly score including their archetype rank. For code units with more than one archetype, the one with the higher rank is shown. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

 MATCH (codeUnit)
 WHERE $projection_node_label IN labels(codeUnit)
UNWIND keys(codeUnit) AS codeUnitProperty
  WITH *
 WHERE codeUnitProperty STARTS WITH 'anomaly'
   AND codeUnitProperty ENDS   WITH 'Rank'
  WITH *
      ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
      ,split(split(codeUnitProperty, 'anomaly')[1], 'Rank')[0] AS archetype             
      ,codeUnit[codeUnitProperty]                              AS archetypeRank
      ,codeUnit.anomalyScore                                   AS anomalyScore
 ORDER BY codeUnit.anomalyScore DESC, archetypeRank ASC, codeUnitName ASC, archetype ASC
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name                                             AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/'))            AS projectName
OPTIONAL MATCH (codeDirectory:File:Directory)-[:CONTAINS]->(codeUnit)
    WITH *, split(replace(codeDirectory.fileName, './', ''), '/')[-2] AS directoryName
    WITH *, coalesce(artifactName, projectName, directoryName, "")    AS projectName
RETURN projectName                                                            AS `Contained in`
      //$projection_language + ' ' +  $projection_node_label                  AS `Code Unit`
      ,codeUnitName                                                           AS `Name`
      ,round(anomalyScore, 4, 'HALF_UP')                                      AS `Score`
      ,collect(archetype)[0]                                                  AS `Archetype`
      ,collect(archetypeRank)[0]                                              AS `Archetype Rank`
      ,nullif(codeUnit.anomalyTopFeature1, "")                                AS `Top Feature 1`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue1, 4, 'HALF_UP'), 0.0) AS `Top Feature 1 SHAP`
      ,nullif(codeUnit.anomalyTopFeature2, "")                                AS `Top Feature 2`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue2, 4, 'HALF_UP'), 0.0) AS `Top Feature 2 SHAP`
      ,nullif(codeUnit.anomalyTopFeature3, "")                                AS `Top Feature 3`
      ,nullif(round(codeUnit.anomalyTopFeatureSHAPValue3, 4, 'HALF_UP'), 0.0) AS `Top Feature 3 SHAP`
      ,CASE WHEN codeUnit.anomalyScore <= 0          THEN 'Typical'
            WHEN codeUnit.anomalyTopFeature1 IS NULL THEN 'Undetermined'
                                                     ELSE 'Anomalous'     END AS `Model Status`
      //,collect(archetype)[1]     AS secondaryArchetype
      //,collect(archetypeRank)[1] AS secondaryArchetypeRank