// External types per artifact using requires

MATCH (artifact:Artifact)-[:REQUIRES]->(externalType:ExternalType)
MATCH (artifact)-[:CONTAINS]->(caller:Type)
OPTIONAL MATCH (caller)-[callerDependency:DEPENDS_ON]->(externalType)
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