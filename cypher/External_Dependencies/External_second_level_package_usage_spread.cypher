// External second level package usage spread. Requires "Add_file_name and_extension.cypher".

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
// Filter out dependencies to external annotations
 WHERE NOT externalType:ExternalAnnotation
  WITH artifactName
      ,artifactPackages
      ,artifactTypes
      ,apoc.text.join(split(externalType.fqn,'.')[0..2], '.')     AS externalSecondLevelPackageName
      // Gathering counts and numbers for every artifact and the external packages it uses
      ,count(DISTINCT typePackage.fqn)                            AS numberOfPackages
      ,COLLECT(DISTINCT typePackage.fqn)                          AS nameOfPackages
      ,count(DISTINCT type.fqn)                                   AS numberOfTypes
      ,COLLECT(DISTINCT type.fqn )[0..9]                          AS someTypeNames
      ,100.0 / artifactPackages * count(DISTINCT typePackage.fqn) AS packagesCallingExternalRate
      ,100.0 / artifactTypes * count(DISTINCT type.fqn)           AS typesCallingExternalRate
// Group by second level external package
RETURN externalSecondLevelPackageName
      ,count(DISTINCT artifactName)          AS numberOfArtifacts

      // Statistics about the packages and their external package usage count
      ,sum(numberOfPackages)                 AS sumNumberOfPackages
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
      ,sum(numberOfTypes)                 AS sumNumberOfTypes
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

      ,collect(DISTINCT artifactName)[0..4] AS someArtifactNames
      
// Order the results by number of artifacts that use the external package dependency descending
ORDER BY numberOfArtifacts DESC, externalSecondLevelPackageName ASC