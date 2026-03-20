// External package usage per type distribution with external annotations. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type)
  WITH artifact.name  AS artifactName
      ,count(type)                                               AS artifactTypes
      ,collect(type)                                             AS typeList
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
  WITH artifactName
      ,artifactTypes
      ,type.fqn                                                  AS fullTypeName
      ,replace(externalType.fqn, '.' + externalType.name, '')    AS externalPackageName
  WITH artifactName
      ,artifactTypes
      ,fullTypeName
      ,count(DISTINCT externalPackageName) AS numberOfExternalPackages    
  WITH artifactName
      ,artifactTypes
      ,numberOfExternalPackages
      ,count(DISTINCT fullTypeName)   AS numberOfTypes
      ,COLLECT(DISTINCT fullTypeName) AS nameOfTypes
RETURN artifactName
      ,artifactTypes
      ,numberOfExternalPackages
      ,numberOfTypes
      ,100.0 / artifactTypes * numberOfTypes AS numberOfTypesPercentage
      ,nameOfTypes
ORDER BY artifactName ASC, numberOfExternalPackages ASC