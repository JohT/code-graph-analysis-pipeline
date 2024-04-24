//Calculate and set Abstractness for Java Packages including sub-packages 

MATCH path = (package:Java:Package)-[:CONTAINS*0..]->(subpackage:Java:Package)
 WITH *
     ,EXISTS{
        MATCH (package)<-[:CONTAINS]-(ancestor:Package)-[:CONTAINS]->(sibling:Package) 
        WHERE sibling <> package 
      } AS hasSiblingPackages
     ,EXISTS{ (package)-[:CONTAINS]->(:Type) } AS containsTypes
WHERE hasSiblingPackages OR containsTypes
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
 WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,package
     ,sum(subpackage.numberOfTypes)            AS numberTypes
     ,sum(subpackage.numberOfAbstractTypes)    AS numberAbstractTypes
     ,count(path) - 1                          AS numberOfIncludedSubPackages
     ,max(length(path))                        AS maxSubpackageDepth
 WITH *
     ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET package.abstractnessIncludingSubpackages          = abstractness
     ,package.numberOfAbstractTypesIncludingSubpackages = numberAbstractTypes
     ,package.numberOfTypesIncludingSubpackages         = numberTypes
RETURN artifactName
      ,package.fqn   AS fullQualifiedPackageName
      ,package.name  AS packageName
      ,abstractness
      ,numberAbstractTypes
      ,numberTypes
      ,numberOfIncludedSubPackages
      ,maxSubpackageDepth
ORDER BY abstractness ASC, maxSubpackageDepth DESC, numberTypes DESC