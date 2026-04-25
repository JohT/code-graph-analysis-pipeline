//Calculate and set Abstractness for Java Packages including sub-packages. Requires "Add_file_name and_extension.cypher".

MATCH path = (package:Java:Package)-[:CONTAINS*0..]->(subpackage:Java:Package)
 WITH *
     ,EXISTS{
        MATCH (package)<-[:CONTAINS]-(ancestor:Package)-[:CONTAINS]->(sibling:Package) 
        WHERE sibling <> package 
      } AS hasSiblingPackages
     ,EXISTS{ (package)-[:CONTAINS]->(:Type) } AS containsTypes
WHERE hasSiblingPackages OR containsTypes
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
 WITH artifact.name AS artifactName
     ,package
     ,sum(subpackage.numberOfTypes)            AS numberTypes
     ,sum(subpackage.numberOfAbstractTypes)    AS numberAbstractTypes
     ,sum(subpackage.numberOfAbstractClasses)  AS numberAbstractClasses
     ,count(path) - 1                          AS numberOfIncludedSubPackages
     ,max(length(path))                        AS maxSubpackageDepth
 WITH *
      // Calculate abstract classes out of abstract types and then add 70% of them back in (weighted)
     ,numberAbstractTypes - (numberAbstractClasses * 0.3) AS weightedAbstractTypes
 WITH *
     ,toFloat(weightedAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET package.abstractnessIncludingSubpackages          = abstractness
     ,package.numberOfAbstractTypesIncludingSubpackages = numberAbstractTypes
     ,package.numberOfTypesIncludingSubpackages         = numberTypes
RETURN artifactName
      ,package.fqn   AS fullQualifiedPackageName
      ,package.name  AS packageName
      ,abstractness
      ,numberAbstractTypes
      ,numberTypes
      ,numberAbstractClasses
      ,weightedAbstractTypes
      ,numberOfIncludedSubPackages
      ,maxSubpackageDepth
ORDER BY abstractness ASC, maxSubpackageDepth DESC, numberTypes DESC