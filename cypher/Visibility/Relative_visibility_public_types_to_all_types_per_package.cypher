// Relative visibility: public types to all types per package. Requires "Add_file_name and_extension.cypher".

         MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
         MATCH (package)-[:CONTAINS]->(anyType:Type)
OPTIONAL MATCH (package)-[:CONTAINS]->(publicType:Type{visibility:"public"})
 WITH artifact.name              AS artifactName
     ,package
     ,COUNT(DISTINCT publicType) AS publicTypes
     ,COUNT(DISTINCT anyType)    AS allTypes
 WITH artifactName 
     ,package
     ,publicTypes
     ,allTypes
     ,toFloat(publicTypes) / allTypes AS relativeVisibility
RETURN artifactName
      ,package.fqn AS fullQualifiedPackageName
      ,package.name AS packageName
      ,publicTypes
      ,allTypes
      ,relativeVisibility
ORDER BY relativeVisibility DESC, allTypes DESC, artifactName ASC, packageName ASC