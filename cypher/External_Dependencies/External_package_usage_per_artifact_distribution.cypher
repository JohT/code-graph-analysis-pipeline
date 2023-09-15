// External package usage per artifact distribution

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '')  AS artifactName
      ,count(DISTINCT package.fqn)                               AS artifactPackages
      ,count(DISTINCT type.fqn)                                  AS artifactTypes
      ,collect(type)                                             AS typeList
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
 MATCH (typePackage:Package)-[:CONTAINS]->(type)
 WHERE NOT externalType:ExternalAnnotation
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,typePackage.fqn                                           AS packageName
      ,type.fqn                                                  AS fullTypeName
      ,replace(externalType.fqn, '.' + externalType.name, '')    AS externalPackageName
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,count(DISTINCT externalPackageName)   AS numberOfExternalPackages
      ,COLLECT(DISTINCT externalPackageName) AS nameOfExternalPackages
      ,count(DISTINCT packageName)           AS numberOfPackages
      ,COLLECT(DISTINCT packageName)         AS nameOfPackages
      ,count(DISTINCT fullTypeName)          AS numberOfTypes
      ,COLLECT(DISTINCT fullTypeName)        AS nameOfTypes
RETURN artifactName
      ,artifactPackages
      ,artifactTypes
      ,numberOfExternalPackages
      ,numberOfPackages
      ,numberOfTypes
      ,100.0 / artifactTypes * numberOfTypes       AS typesCallingExternalRate
      ,100.0 / artifactPackages * numberOfPackages AS packagesCallingExternalRate
      ,nameOfExternalPackages[0..9]                AS someExternalPackageNames
      ,nameOfPackages[0..9]                        AS someExternalCallingPackageNames
      ,nameOfTypes[0..9]                           AS someExternalCallingTypeNames
ORDER BY numberOfPackages DESC, artifactName ASC