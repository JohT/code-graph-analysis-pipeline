// Artifacts with dependencies to other artifacts

MATCH (artifact:Artifact)-[:CONTAINS]->(packageInArtifact:Package)
MATCH (packageInArtifact)-[:CONTAINS]->(typeInPackage:Type)
MATCH (typeInPackage)-[:DEPENDS_ON]->(dependencyType:Type)
MATCH (dependencyPackage:Package)-[:CONTAINS]->(dependencyType)
MATCH (dependencyArtifact:Artifact)-[:CONTAINS]->(dependencyPackage)
WHERE artifact.fileName <> dependencyArtifact.fileName
 WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,artifact.numberOfPackages               AS packagesInArtifactCount
     ,artifact.numberOfTypes                  AS typesInArtifactCount
     ,collect(DISTINCT packageInArtifact.fqn) AS packages
     ,count(DISTINCT packageInArtifact.fqn)   AS packagesCount
     ,round(100.0 / artifact.numberOfPackages 
                 * count(DISTINCT packageInArtifact.fqn)
           , 2)                               AS packageSpread
     ,collect(DISTINCT typeInPackage.name)    AS types
     ,count(DISTINCT typeInPackage.fqn)       AS typesCount
     ,round(100.0 / artifact.numberOfTypes 
                  * count(DISTINCT typeInPackage.fqn)
           , 2)                               AS typesSpread 
     ,replace(last(split(dependencyArtifact.fileName, '/')), '.jar', '') AS dependencyArtifactName
// additionally group by if the dependency is an interface or not
     ,dependencyType:Interface                AS dependencyTypeIsInterface 
     ,collect(DISTINCT dependencyPackage.fqn) AS dependencyPackages
     ,count(DISTINCT dependencyPackage.fqn)   AS dependencyPackagesCount
     ,collect(DISTINCT dependencyType.name)   AS dependencyTypes
     ,count(DISTINCT dependencyType.fqn)      AS dependencyTypesCount
// Filter out empty dependency sets
WHERE dependencyPackagesCount > 0
  AND packagesCount > 1
RETURN artifactName
      ,packagesInArtifactCount
      ,packagesCount
      ,packageSpread 
      ,typesInArtifactCount
      ,typesCount
      ,typesSpread 
      ,dependencyArtifactName
      ,dependencyTypeIsInterface
      ,dependencyPackagesCount
      ,dependencyTypesCount
      ,dependencyPackages[0..2]    AS someDependencyPackages
      ,dependencyTypes[0..4]       AS someDependencyTypes
      ,packages[0..2]              AS someCallingPackages
      ,types[0..4]                 AS someCallingTypes
ORDER BY packagesCount DESC