// External package usage per type

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
  WITH externalDependency
      ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn  AS fullPackageName
      ,package.name AS packageName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
  WITH artifactName
      ,fullPackageName
      ,packageName
      ,fullTypeName
      ,typeName
      ,count(externalDependency)             AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)        AS numberOfExternalTypeCalls
      ,count  (DISTINCT externalPackageName) AS numberOfExternalPackages
      ,collect(DISTINCT externalPackageName) AS externalPackageNames
      ,count  (DISTINCT externalPackageName + '.' + externalTypeName) AS numberOfExternalTypes
      ,collect(DISTINCT externalPackageName + '.' + externalTypeName) AS externalTypeNames
RETURN artifactName, fullPackageName, typeName
      ,numberOfExternalTypeCaller, numberOfExternalTypeCalls, numberOfExternalPackages, numberOfExternalTypes
      ,externalPackageNames, externalTypeNames
      ,packageName
      ,fullTypeName
ORDER BY numberOfExternalPackages DESC, artifactName ASC, fullPackageName ASC