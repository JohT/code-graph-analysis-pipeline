// Anomaly Detection Query: Find potential over-engineered or isolated code unit by listing the top 20 entries with the highest local clustering coefficient and a Page Rank below the 5% percentile.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.centralityPageRank                  IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH collect(codeUnit) AS codeUnits
        ,percentileDisc(codeUnit.centralityPageRank, 0.10)                  AS pageRank10PercentPercentile
        ,percentileDisc(codeUnit.communityLocalClusteringCoefficient, 0.90) AS localClusteringCoefficient90PercentPercentile
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE codeUnit.centralityPageRank                  <= pageRank10PercentPercentile
     AND codeUnit.communityLocalClusteringCoefficient >= localClusteringCoefficient90PercentPercentile
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(artifactName, projectName)          AS projectName
        ,codeUnit.communityLocalClusteringCoefficient AS localClusteringCoefficient
        ,codeUnit.centralityPageRank                  AS pageRank
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY localClusteringCoefficient DESC, pageRank ASC
  LIMIT 20