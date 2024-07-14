// Global relative visibility statistics for elements for Typescript

         MATCH (project:Directory)<-[:HAS_ROOT]-(:Project)-[:CONTAINS]->(module:TS:Module)
         MATCH (module)-[:DECLARES]->(anyElement:TS)
OPTIONAL MATCH (module)-[:EXPORTS]->(exportedElement:TS)
 WITH project.absoluteFileName AS projectPath
     ,module
     ,COUNT(DISTINCT exportedElement) AS exportedElements
     ,COUNT(DISTINCT anyElement)      AS allElements
 WITH projectPath
     ,module
     ,exportedElements
     ,allElements
     ,toFloat(exportedElements) / allElements AS relativeVisibility
 WITH projectPath
     ,SUM(exportedElements)   AS exported
     ,SUM(allElements)        AS all
     ,AVG(relativeVisibility) AS average
     ,MIN(relativeVisibility) AS min
     ,MAX(relativeVisibility) AS max
     ,percentileCont(relativeVisibility, 0.25) AS percentile25
     ,percentileCont(relativeVisibility, 0.5)  AS percentile50
     ,percentileCont(relativeVisibility, 0.75) AS percentile75
     ,percentileCont(relativeVisibility, 0.90) AS percentile90
     ,percentileCont(relativeVisibility, 0.95) AS percentile95
     ,percentileCont(relativeVisibility, 0.99) AS percentile99
RETURN projectPath
      ,all
      ,exported
      ,min
      ,max
      ,average
      ,percentile25
      ,percentile50
      ,percentile75
      ,percentile90
      ,percentile95
      ,percentile99
ORDER BY projectPath