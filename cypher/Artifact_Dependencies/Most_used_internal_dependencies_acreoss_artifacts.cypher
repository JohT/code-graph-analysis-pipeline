// Most used internal dependencies across artifacts. Requires "Add_file_name and_extension.cypher".

MATCH (type:Type)-[:DEPENDS_ON]->(dependencyType:Type)
MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
MATCH (dependencyArtifact:Artifact)-[:CONTAINS]->(dependencyPackage:Package)-[:CONTAINS]->(dependencyType)
WHERE artifact.fileName <> dependencyArtifact.fileName
 WITH dependencyArtifact.name    AS dependencyArtifactName
     ,COLLECT(DISTINCT dependencyPackage.fqn)                               AS dependencyPackageNames
     ,COLLECT(DISTINCT dependencyType.name)                                 AS dependencyTypeNames
     ,COLLECT(DISTINCT artifact.name) AS artifactNames
     ,COUNT(DISTINCT package.fqn)                                           AS numberOfPackages
     ,COUNT(DISTINCT type.fqn)                                              AS numberOfTypes
     ,COUNT(DISTINCT dependencyType)                                        AS numberOfDependencyTypes
     ,REDUCE(interfaces=0, depType IN COLLECT(DISTINCT dependencyType) | 
         CASE WHEN depType:Interface THEN interfaces + 1 ELSE interfaces END ) AS numberOfDependencyInterfaces
 ORDER BY numberOfPackages DESC
RETURN dependencyArtifactName                                                   AS dependency
      ,numberOfPackages                                                         AS usedByPackages
      ,numberOfTypes                                                            AS usedByTypes
      ,SIZE(dependencyPackageNames)                                             AS providesPackages
      ,SIZE(dependencyTypeNames)                                                AS providesTypes
      ,ROUND(100.0 / numberOfDependencyTypes * numberOfDependencyInterfaces, 2) AS interfaceRate
      ,dependencyPackageNames[0..5]                                             AS someProvidedPackages      
      ,dependencyTypeNames[0..5]                                                AS someProvidedTypes     