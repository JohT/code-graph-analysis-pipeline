// Anomaly Detection Summary: Summarizes all labelled archetypes by their anomaly score including examples. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

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
  WITH *, collect(archetype)[0] AS archetype
 ORDER BY codeUnit.anomalyScore DESC, archetypeRank ASC, codeUnitName ASC, archetype ASC
  WITH archetype
      ,anomalyScore
      ,CASE WHEN codeUnit.anomalyScore <= 0          THEN 'Typical'
            WHEN codeUnit.anomalyTopFeature1 IS NULL THEN 'Undetermined'
                                                     ELSE 'Anomalous'     END AS modelStatus
      ,codeUnitName
RETURN archetype                               AS `Archetype`
      ,count(DISTINCT codeUnitName)            AS `Count`
      ,round(max(anomalyScore), 4, 'HALF_UP')  AS `Max. Score` 
      ,modelStatus                             AS `Model Status`  
      ,apoc.text.join(collect(DISTINCT codeUnitName)[0..3], ', ')    AS `Examples`
ORDER BY modelStatus, archetype, `Max. Score` DESC