// Anomaly Detection Query: Find dependency hungry orchestrators by listing the top 20 entries with the highest Article Rank >= 90% percentile and a Betweeenness centrality >= 90% percentile.
// Shows key code that depend on many others and also controls flow — likely orchestrators or managers.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness               IS NOT NULL
     AND codeUnit.centralityArticleRank               IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                AS codeUnits
        ,percentileDisc(codeUnit.centralityArticleRank, 0.90)             AS articleRank90Percentile
        ,percentileDisc(codeUnit.centralityBetweenness, 0.90)             AS betweenness90Percentile
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE codeUnit.centralityArticleRank    >= articleRank90Percentile
     AND codeUnit.centralityBetweenness    >= betweenness90Percentile
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(artifactName, projectName)          AS projectName
        ,codeUnit.centralityBetweenness               AS betweenness
        ,codeUnit.centralityArticleRank                  AS articleRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY articleRank DESC, betweenness DESC
  LIMIT 20