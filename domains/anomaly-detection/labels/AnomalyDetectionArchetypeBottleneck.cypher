// Anomaly Detection Labels: Label code units of archetype "Bottleneck" by looking for the top 20 entries with the highest Betweeenness centrality >= 90% percentile.  Requires features/*.cypher to be run first.
// Shows key code that is both heavily depended on and control flow — critical hubs.
// Potentially an unintended dependency concentration: if removed, communication between modules breaks.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness               IS NOT NULL
    WITH collect(codeUnit)                                                AS codeUnits
        ,percentileDisc(codeUnit.centralityBetweenness, 0.90)             AS betweennessThreshold
  UNWIND codeUnits AS codeUnit
    WITH *
   WHERE codeUnit.centralityBetweenness >= betweennessThreshold
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
    WITH *, coalesce(artifactName, projectName)            AS projectName
   ORDER BY codeUnit.centralityBetweenness DESC
   LIMIT 10
    WITH collect([codeUnit, projectName]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
     SET codeUnit:Mark4TopAnomalyBottleneck
        ,codeUnit.anomalyBottleneckRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.centralityBetweenness               AS betweenness
        ,codeUnit.anomalyBottleneckRank               AS rank