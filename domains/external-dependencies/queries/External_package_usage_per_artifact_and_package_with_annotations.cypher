// External package usage per artifact and package with external annotations. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
  WITH artifact.name AS artifactName
      ,package.fqn   AS fullPackageName
      ,package.name  AS packageName
      ,count(type)   AS numberOfTypesInPackage
      ,collect(type) AS typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
  WITH numberOfTypesInPackage
      ,externalDependency
      ,artifactName
      ,fullPackageName
      ,packageName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
  WITH numberOfTypesInPackage
      ,artifactName
      ,fullPackageName
      ,packageName
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
RETURN artifactName, fullPackageName
      ,externalPackageName
      ,numberOfExternalTypeCaller, numberOfExternalTypeCalls, numberOfTypesInPackage
      ,externalTypeNames
      ,packageName
ORDER BY numberOfExternalTypeCaller DESC, artifactName ASC, fullPackageName ASC