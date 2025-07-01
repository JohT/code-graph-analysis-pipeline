// Anomaly Detection Query: Find fragile structural bridges, potential boundary-spanning modules and cohesion violations by listing the top 20 entries with the highest Betweeenness centrality >= 90% percentile and a local clustering coefficient <= 10% percentile.
// Shows code that connects otherwise unrelated parts of the graph — potential architectural risks.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness               IS NOT NULL
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit)                                                  AS codeUnits
        ,percentileDisc(codeUnit.communityLocalClusteringCoefficient, 0.10) AS localClusteringCoefficient10Percentile
        ,percentileDisc(codeUnit.centralityBetweenness, 0.90)               AS betweenness90Percentile
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies   AS degree
   WHERE codeUnit.communityLocalClusteringCoefficient <= localClusteringCoefficient10Percentile
     AND codeUnit.centralityBetweenness               >= betweenness90Percentile
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(artifactName, projectName)          AS projectName
        ,codeUnit.centralityBetweenness               AS betweenness
        ,codeUnit.communityLocalClusteringCoefficient AS localClusteringCoefficient
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY betweenness DESC, localClusteringCoefficient ASC
  LIMIT 20