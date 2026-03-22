// External package usage per internal package count. Requires "Add_file_name and_extension.cypher".

// Get the overall artifact statistics first
 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 WHERE NOT type:ExternalType
  WITH artifact.name  AS artifactName
      ,count(DISTINCT package.fqn)                               AS artifactPackages
      ,count(DISTINCT type.fqn)                                  AS artifactTypes
      ,collect(type)                                             AS typeList
// Get the external dependencies for each internal type
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
 MATCH (typePackage:Package)-[:CONTAINS]->(type)
// Optionally filter out dependencies to external annotations
// WHERE NOT externalType:ExternalAnnotation
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,typePackage.fqn                                           AS packageName
      ,type.fqn                                                  AS fullTypeName
      ,replace(externalType.fqn, '.' + externalType.name, '')    AS externalPackageName
// Group by artifact and external package
WITH   artifactName
      ,artifactPackages
      ,artifactTypes
      ,externalPackageName
      ,count(DISTINCT packageName)          AS numberOfPackages
      ,count(DISTINCT fullTypeName)         AS numberOfTypes
      ,100.0 / artifactPackages * count(DISTINCT packageName) AS packagesCallingExternalRate
      ,100.0 / artifactTypes * count(DISTINCT fullTypeName)   AS typesCallingExternalRate
      ,COLLECT(DISTINCT packageName)        AS nameOfPackages
      ,COLLECT(DISTINCT fullTypeName)[0..9] AS someTypeNames
RETURN artifactName
      ,artifactPackages
      ,artifactTypes
      ,numberOfPackages
      ,count(DISTINCT externalPackageName)   AS numberOfExternalPackages
      ,collect(DISTINCT externalPackageName) AS externalPackageNames
      ,max(packagesCallingExternalRate)       AS maxPackagesCallingExternalRate
      ,max(typesCallingExternalRate)         AS maxTypesCallingExternalRate
      ,COLLECT(nameOfPackages)[0][0..9]      AS somePackageNames
      ,COLLECT(someTypeNames)[0]             AS someTypeNames
// Order the results by number of packages that use the external package dependency descending
ORDER BY numberOfPackages DESC, artifactName ASC