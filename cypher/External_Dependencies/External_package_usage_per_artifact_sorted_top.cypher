// External package usage per artifact top externals

 MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(type:Type)
 OPTIONAL MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
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
 ORDER BY externalTypeRate DESC, artifactName ASC
  WITH numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,externalTypeRate
      ,artifactName
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
 ORDER BY externalTypeRate DESC, artifactName ASC, numberOfExternalTypeCaller DESC
  WITH numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,externalTypeRate
      ,artifactName
      ,COLLECT(DISTINCT externalPackageName) AS externalPackageNames
      ,SUM(numberOfExternalTypeCaller)       AS numberOfExternalTypeCaller
      ,sum(numberOfExternalTypeCalls)        AS numberOfExternalTypeCalls
      ,collect(externalTypeNames)            AS externalTypeNames
RETURN artifactName
      ,numberOfTypesInArtifact
      ,numberOfExternalTypesInArtifact
      ,numberOfExternalPackagesInArtifact
      ,externalTypeRate
      ,numberOfExternalTypeCaller
      ,numberOfExternalTypeCalls
      ,size(externalPackageNames) AS numberOfExternalPackages
      ,externalPackageNames[0..4] AS top5ExternalPackages
      ,externalTypeNames[0..1]    AS someExternalTypes
LIMIT 40