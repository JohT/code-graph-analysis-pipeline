// Anomaly Detection Query: Find popular bottlenecks by listing the top 20 entries with the highest Betweeenness centrality >= 90% percentile and a Page Rank >= 90% percentile.
// Shows key code that is both heavily depended on and control flow — critical hubs.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness               IS NOT NULL
     AND codeUnit.centralityPageRank               IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                AS codeUnits
        ,percentileDisc(codeUnit.centralityPageRank, 0.90)                AS pageRank90Percentile
        ,percentileDisc(codeUnit.centralityBetweenness, 0.90)             AS betweenness90Percentile
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE codeUnit.centralityPageRank    >= pageRank90Percentile
     AND codeUnit.centralityBetweenness >= betweenness90Percentile
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(artifactName, projectName)          AS projectName
        ,codeUnit.centralityBetweenness               AS betweenness
        ,codeUnit.centralityPageRank                  AS pageRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY pageRank DESC, betweenness DESC
  LIMIT 20