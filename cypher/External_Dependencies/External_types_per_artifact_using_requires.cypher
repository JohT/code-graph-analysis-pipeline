// External types per artifact using requires

MATCH (artifact:Artifact)-[:REQUIRES]->(externalType:Type)
MATCH (artifact)-[:CONTAINS]->(caller:Type)
OPTIONAL MATCH (caller)-[callerDependency:DEPENDS_ON]->(externalType)
WHERE NOT externalType.fqn STARTS WITH 'java.' // ignore 
  AND externalType.fqn CONTAINS '.' // ignore primitives
  AND NOT EXISTS((externalType)-[:RESOLVES_TO]->(:Type))
 WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,replace(externalType.fqn, '.' + externalType.name, '') AS externalTypePackage
     ,COLLECT(DISTINCT externalType.name)   AS externalTypeNames
     ,COUNT(callerDependency)               AS numberOfCaller
     ,sum(callerDependency.weight)          AS numberOfCalls
     ,COUNT(DISTINCT caller)                AS numberOfAllTypes
WHERE numberOfCalls > 0
RETURN artifactName
      ,externalTypePackage
      ,numberOfCaller
      ,numberOfCalls
      ,numberOfAllTypes
      ,externalTypeNames
 ORDER BY artifactName ASC, numberOfCaller DESC