// External package usage per artifact package aggregated. Requires "Add_file_name and_extension.cypher".

// Get the overall artifact statistics first
 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 WHERE NOT type:ExternalType
  WITH artifact.name  AS artifactName
      ,artifact.communityLeidenId                                AS leidenCommunityId
      ,count(DISTINCT package.fqn)                               AS artifactPackages
      ,count(DISTINCT type.fqn)                                  AS artifactTypes
      ,collect(type)                                             AS typeList
// Get the external dependencies for each internal type
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:ExternalType)
 MATCH (typePackage:Package)-[:CONTAINS]->(type)
// Filter out dependencies to exxternal annotations
 WHERE NOT externalType:ExternalAnnotation
  WITH artifactName
      ,leidenCommunityId
      ,artifactPackages
      ,artifactTypes
      ,typePackage.fqn                                           AS packageName
      ,type.fqn                                                  AS fullTypeName
      ,replace(externalType.fqn, '.' + externalType.name, '')    AS externalPackageName
// Group by artifact and external package
  WITH artifactName
      ,leidenCommunityId
      ,artifactPackages
      ,artifactTypes
      ,externalPackageName
      ,count(DISTINCT packageName)         AS numberOfPackages
      ,COLLECT(DISTINCT packageName)       AS nameOfPackages
      ,count(DISTINCT fullTypeName)        AS numberOfTypes
      ,COLLECT(DISTINCT fullTypeName)      AS nameOfTypes
      ,100.0 / artifactPackages * count(DISTINCT packageName) AS packagesCallingExternalRate
      ,100.0 / artifactTypes * count(DISTINCT fullTypeName)   AS typesCallingExternalRate
// Pre order the results by number of packages that use the external package dependency descending
ORDER BY numberOfPackages DESC, artifactName ASC
// Optionally filter out external package dependencies that are only used by one package
// WHERE numberOfPackages > 1
// Group by artifact, aggregate statistics and return the results
RETURN artifactName
      ,leidenCommunityId
      ,artifactPackages
      ,artifactTypes
      ,count(DISTINCT externalPackageName)   AS numberOfExternalPackages
      
      // Statistics about the packages and their external package usage count
      ,min(numberOfPackages)                 AS minNumberOfPackages
      ,max(numberOfPackages)                 AS maxNumberOfPackages
      ,percentileCont(numberOfPackages, 0.5) AS medNumberOfPackages
      ,avg(numberOfPackages)                 AS avgNumberOfPackages
      ,stDev(numberOfPackages)               AS stdNumberOfPackages

      // Statistics about the packages and their external package usage percentage
      ,min(packagesCallingExternalRate)                 AS minNumberOfPackagesPercentage
      ,max(packagesCallingExternalRate)                 AS maxNumberOfPackagesPercentage
      ,percentileCont(packagesCallingExternalRate, 0.5) AS medNumberOfPackagesPercentage
      ,avg(packagesCallingExternalRate)                 AS avgNumberOfPackagesPercentage
      ,stDev(packagesCallingExternalRate)               AS stdNumberOfPackagesPercentage

      // Statistics about the types and their external package usage count
      ,min(numberOfTypes)                 AS minNumberOfTypes
      ,max(numberOfTypes)                 AS maxNumberOfTypes
      ,percentileCont(numberOfTypes, 0.5) AS medNumberOfTypes
      ,avg(numberOfTypes)                 AS avgNumberOfTypes
      ,stDev(numberOfTypes)               AS stdNumberOfTypes

      // Statistics about the types and their external package usage count percentage
      ,min(typesCallingExternalRate)                 AS minNumberOfTypesPercentage
      ,max(typesCallingExternalRate)                 AS maxNumberOfTypesPercentage
      ,percentileCont(typesCallingExternalRate, 0.5) AS medNumberOfTypesPercentage
      ,avg(typesCallingExternalRate)                 AS avgNumberOfTypesPercentage
      ,stDev(typesCallingExternalRate)               AS stdNumberOfTypesPercentage

      // Examples of external packages, caller packages and caller types
      ,collect(externalPackageName)[0..9]            AS top10ExternalPackageNamesByUsageDescending
      ,COLLECT(nameOfPackages)[0][0..9]              AS somePackageNames
      ,COLLECT(nameOfTypes)[0][0..9]                 AS someTypeNames

ORDER BY maxNumberOfPackages DESC, artifactName ASC