// External second level package usage per artifact and external package

// Get the overall artifact statistics first
 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 OPTIONAL MATCH (packageUsingExternal:Package)-[:CONTAINS]->(type)-[:DEPENDS_ON]->(external:ExternalType)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '')       AS artifactName
      ,count(DISTINCT package.fqn)                                    AS artifactPackages
      ,count(DISTINCT type.fqn)                                       AS artifactTypes
      ,count(DISTINCT split(external.fqn,'.')[0..2])                  AS artifactExternalPackagesFirst2Levels
      ,count(DISTINCT packageUsingExternal.fqn)                       AS artifactExternalCallingPackages
      ,collect(type)                                                  AS typeList
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,artifactExternalPackagesFirst2Levels
      ,artifactExternalCallingPackages
      ,round((100.0 / artifactPackages * artifactExternalCallingPackages), 2) AS artifactExternalCallingPackagesRate
      ,typeList
// Get the external dependencies for each internal type
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
 MATCH (typePackage:Package)-[:CONTAINS]->(type)
// Optionally filter out dependencies to external annotations
// WHERE NOT externalType:ExternalAnnotation
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,artifactExternalPackagesFirst2Levels
      ,artifactExternalCallingPackages
      ,artifactExternalCallingPackagesRate
      ,typePackage.fqn                                           AS packageName
      ,type.fqn                                                  AS fullTypeName
      ,apoc.text.join(split(externalType.fqn,'.')[0..2], '.')    AS externalPackageNameFirst2Levels
// Group by artifact and first to external package levels
RETURN artifactName
      ,artifactPackages
      ,artifactTypes
      ,artifactExternalPackagesFirst2Levels
      ,artifactExternalCallingPackages
      ,artifactExternalCallingPackagesRate
      ,externalPackageNameFirst2Levels
      ,count(DISTINCT packageName)          AS numberOfPackages
      ,count(DISTINCT fullTypeName)         AS numberOfTypes
      ,100.0 / artifactPackages * count(DISTINCT packageName) AS packagesCallingExternalRate
      ,100.0 / artifactTypes * count(DISTINCT fullTypeName)   AS typesCallingExternalRate
      ,COLLECT(DISTINCT packageName)        AS nameOfPackages
      ,COLLECT(DISTINCT fullTypeName)[0..9] AS someTypeNames
// Order the results by number of packages that use the external package dependency descending
ORDER BY artifactExternalCallingPackagesRate DESC, artifactName ASC, numberOfPackages DESC, externalPackageNameFirst2Levels ASC