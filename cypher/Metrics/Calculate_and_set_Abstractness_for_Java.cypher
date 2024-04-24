//Calculate and set Abstractness for Java Packages including Counts 

MATCH (package:Java:Package)
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
 WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,package
     ,count{(package)-[:CONTAINS]->(:Type)}                    AS numberTypes
     ,count{(package)-[:CONTAINS]->(:Class{abstract:true})}    AS numberAbstractClasses
     ,count{(package)-[:CONTAINS]->(:Annotation)}              AS numberAnnotations
     ,count{(package)-[:CONTAINS]->(:Interface)}               AS numberInterfaces
 WITH *
     ,numberInterfaces + numberAnnotations + numberAbstractClasses AS numberAbstractTypes
 WITH *
     ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET package.abstractness          = abstractness
     ,package.numberOfAbstractTypes = numberAbstractTypes
     ,package.numberOfTypes         = numberTypes
RETURN artifactName
      ,package.fqn  AS fullQualifiedPackageName
      ,package.name AS packageName
      ,abstractness
      ,numberAbstractTypes
      ,numberTypes
ORDER BY abstractness ASC, numberTypes DESC