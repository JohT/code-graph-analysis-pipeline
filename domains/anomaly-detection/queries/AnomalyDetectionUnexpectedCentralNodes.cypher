// Anomaly Detection Query: Find hidden bottlenecks or hubs by listing the top 20 entries with the highest betweeenness >= 90% percentile and a degree <= 10% percentile.
// Shows code with high structural importance and only a few incoming and outgoing dependencies  — often unexpected.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityBetweenness               IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
    WITH collect(codeUnit)                                                AS codeUnits
        ,percentileDisc(degree, 0.10)                                     AS degree10Percentile
        ,percentileDisc(codeUnit.centralityBetweenness, 0.90)             AS betweenness90Percentile
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE degree                         <= degree10Percentile
     AND codeUnit.centralityBetweenness <= betweenness90Percentile
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(artifactName, projectName)          AS projectName
        ,codeUnit.centralityBetweenness               AS betweenness
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
  ORDER BY betweenness DESC, degree ASC
  LIMIT 20