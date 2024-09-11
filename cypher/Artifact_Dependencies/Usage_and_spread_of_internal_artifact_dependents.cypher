// Usage and spread of internal artifact dependents. Requires "Add_file_name and_extension.cypher".

MATCH (artifact:Artifact)-[:CONTAINS]->(packageInArtifact:Package)
MATCH (packageInArtifact)-[:CONTAINS]->(typeInPackage:Type)
MATCH (typeInPackage)-[:DEPENDS_ON]->(dependencyType:Type)
MATCH (dependencyPackage:Package)-[:CONTAINS]->(dependencyType)
MATCH (dependencyArtifact:Artifact)-[:CONTAINS]->(dependencyPackage)
WHERE artifact.fileName <> dependencyArtifact.fileName
 WITH artifact.name AS artifactName
     ,artifact.numberOfPackages                AS packagesInArtifactCount
     ,artifact.numberOfTypes                   AS typesInArtifactCount
     ,collect(DISTINCT packageInArtifact.fqn)  AS packages
     ,count(DISTINCT packageInArtifact.fqn)    AS packagesCount
     ,(100.0 
       / artifact.numberOfPackages 
       * count(DISTINCT packageInArtifact.fqn)) AS packageSpread
     ,collect(DISTINCT typeInPackage.name)     AS types
     ,count(DISTINCT typeInPackage.fqn)        AS typesCount
     ,(100.0 
       / artifact.numberOfTypes 
       * count(DISTINCT typeInPackage.fqn))     AS typesSpread 
     ,dependencyArtifact.name AS dependencyArtifactName
// additionally group by if the dependency is an interface or not
     ,dependencyType:Interface                 AS dependencyTypeIsInterface 
     ,collect(DISTINCT dependencyPackage.fqn)  AS dependencyPackages
     ,count(DISTINCT dependencyPackage.fqn)    AS dependencyPackagesCount
     ,collect(DISTINCT dependencyType.name)    AS dependencyTypes
     ,count(DISTINCT dependencyType.fqn)       AS dependencyTypesCount
// Filter out empty dependency sets
WHERE dependencyPackagesCount > 0
  AND packagesCount > 1
RETURN artifactName
     ,dependencyTypeIsInterface
     ,COUNT(DISTINCT dependencyArtifactName)   AS artifactDependencies
     ,SUM(dependencyPackagesCount)             AS artifactDependencyPackages
     ,100.0 / SUM(packagesInArtifactCount) * SUM(packagesCount) AS dependentPackagesRate
     
     ,MIN(packageSpread)                 AS minPackageSpread
     ,MAX(packageSpread)                 AS maxPackageSpread
     ,AVG(packageSpread)                 AS avgPackageSpread
     ,stDev(packageSpread)               AS stdPackageSpread
     ,percentileDisc(packageSpread, 0.5) AS per5PackageSpread
     
     ,MIN(packagesCount)                 AS minPackageCount
     ,MAX(packagesCount)                 AS maxPackageCount
     ,AVG(packagesCount)                 AS avgPackageCount
     ,stDev(packagesCount)               AS stdPackageCount
     ,percentileDisc(packagesCount, 0.5) AS per5PackageCount

     ,MIN(typesSpread)                   AS minTypeSpread
     ,MAX(typesSpread)                   AS maxTypeSpread
     ,AVG(typesSpread)                   AS avgTypeSpread
     ,stDev(typesSpread)                 AS stdTypeSpread
     ,percentileDisc(typesSpread, 0.5)   AS per5TypeSpread
ORDER BY toLower(artifactName) ASC