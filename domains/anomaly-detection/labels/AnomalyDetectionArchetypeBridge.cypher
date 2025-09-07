// Anomaly Detection Labels: Label code units of archetype "Bridge" by looking for the (at most) top 20 entries with the sum of the "nodeEmbedding" anomaly detection feature SHAP (explainable AI) values. Requires anomalyDetectionExplained.py to be run first.
// Shows code that integrates various layers or boundaries (e.g., API facades) or violates architecture (tangled dependencies).

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.anomalyNodeEmbeddingSHAPSum < 0
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name                                  AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName 
    WITH *, coalesce(artifactName, projectName)            AS projectName  
   ORDER BY codeUnit.anomalyNodeEmbeddingSHAPSum ASC
   LIMIT 10
    WITH collect([codeUnit, projectName]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
     SET codeUnit:Mark4TopAnomalyBridge
        ,codeUnit.anomalyBridgeRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                     AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.anomalyNodeEmbeddingSHAPSum              AS nodeEmbeddingTop3SHAPValueSum
        ,codeUnit.anomalyBridgeRank                        AS rank