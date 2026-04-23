//Calculate and set Abstractness for Java Packages including Counts. Requires "Add_file_name and_extension.cypher".

MATCH (package:Java:Package)
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
 WITH artifact.name AS artifactName
     ,package
     ,count{(package)-[:CONTAINS]->(:Type)}                    AS numberTypes
     ,count{(package)-[:CONTAINS]->(:Class{abstract:true})}    AS numberAbstractClasses
     ,count{(package)-[:CONTAINS]->(:Annotation)}              AS numberAnnotations
     ,count{(package)-[:CONTAINS]->(:Interface)}               AS numberInterfaces
 WITH *
     ,numberInterfaces + numberAnnotations +  numberAbstractClasses        AS numberAbstractTypes
     ,numberInterfaces + numberAnnotations + (numberAbstractClasses * 0.7) AS weightedAbstractTypes
 WITH *
     ,toFloat(weightedAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET package.abstractness            = abstractness
     ,package.numberOfAbstractTypes   = numberAbstractTypes
     ,package.numberOfAbstractClasses = numberAbstractClasses
     ,package.numberOfTypes           = numberTypes
RETURN artifactName
      ,package.fqn  AS fullQualifiedPackageName
      ,package.name AS packageName
      ,abstractness
      ,numberAbstractTypes
      ,numberTypes
      ,numberAbstractClasses
      ,weightedAbstractTypes
ORDER BY abstractness ASC, numberTypes DESC