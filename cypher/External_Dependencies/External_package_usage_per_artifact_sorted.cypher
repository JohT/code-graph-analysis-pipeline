// External package usage per artifact sorted by external usage descending. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(type:Type)
 OPTIONAL MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
  WITH artifact.name AS artifactName
      ,count(DISTINCT type.fqn)         AS numberOfTypesInArtifact
      ,count(DISTINCT externalType.fqn) AS numberOfExternalTypesInArtifact
      ,count(DISTINCT replace(externalType.fqn, '.' + externalType.name, '')) AS numberOfExternalPackagesInArtifact
      ,collect(DISTINCT type) AS typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
  WITH numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,100.0 / numberOfTypesInArtifact * numberOfExternalTypesInArtifact AS externalTypeRate 
      ,externalDependency
      ,artifactName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
  WITH numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,externalTypeRate
      ,artifactName
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
RETURN artifactName
      ,externalPackageName
      ,numberOfExternalTypeCaller
      ,numberOfExternalTypeCalls
      ,numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,externalTypeRate
      ,externalTypeNames
ORDER BY externalTypeRate DESC, artifactName ASC, numberOfExternalTypeCaller DESC, externalPackageName ASC