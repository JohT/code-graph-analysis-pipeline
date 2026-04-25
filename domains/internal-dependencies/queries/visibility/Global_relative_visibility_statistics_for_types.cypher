// Global relative visibility statistics for types. Requires "Add_file_name_and_extension.cypher".

         MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
         MATCH (package)-[:CONTAINS]->(anyType:Type)
  WITH artifact
      ,package
      ,COUNT(DISTINCT anyType)    AS allTypes
OPTIONAL MATCH (package)-[:CONTAINS]->(publicType:Type {visibility: 'public'})
  WITH artifact.name              AS artifact
      ,package
      ,allTypes
      ,COUNT(DISTINCT publicType) AS publicTypes
  WITH artifact
     ,package
     ,publicTypes
     ,allTypes
     ,toFloat(publicTypes) / allTypes AS relativeVisibility
 WITH artifact
     ,SUM(publicTypes)        AS public
     ,SUM(allTypes)           AS all
     ,AVG(relativeVisibility) AS average
     ,MIN(relativeVisibility) AS min
     ,MAX(relativeVisibility) AS max
     ,percentileCont(relativeVisibility, 0.25) AS percentile25
     ,percentileCont(relativeVisibility, 0.5)  AS percentile50
     ,percentileCont(relativeVisibility, 0.75) AS percentile75
     ,percentileCont(relativeVisibility, 0.90) AS percentile90
RETURN artifact
      ,all
      ,public
      ,min
      ,max
      ,average
      ,percentile25
      ,percentile50
      ,percentile75
      ,percentile90
ORDER BY artifact