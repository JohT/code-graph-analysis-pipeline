// External types per artifact using requires. Requires "Add_file_name and_extension.cypher".

MATCH (artifact:Artifact)-[:REQUIRES]->(externalType:ExternalType)
MATCH (artifact)-[:CONTAINS]->(caller:Type)
OPTIONAL MATCH (caller)-[callerDependency:DEPENDS_ON]->(externalType)
 WITH artifact.name AS artifactName
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