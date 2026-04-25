// Relative visibility: exported elements to all elements per module

         MATCH (project:Directory)<-[:HAS_ROOT]-(:Project)-[:CONTAINS]->(module:TS:Module)
         MATCH (module)-[:DECLARES]->(moduleElement:TS)
// Check if element is not only declared but also exported.
// Only EXPORTS refers to re-exported elements.
OPTIONAL MATCH (module)-[:EXPORTS]->(exportedElement:TS)
 WITH project.absoluteFileName        AS projectPath
     ,module
     ,COUNT(DISTINCT exportedElement) AS exportedElements
     ,COUNT(DISTINCT moduleElement)   AS allElements
 WITH projectPath 
     ,module
     ,exportedElements
     ,allElements
     ,toFloat(exportedElements) / allElements AS relativeVisibility
RETURN projectPath
      ,replace(module.fileName, './', '')  AS modulePath
      ,module.name      AS moduleName
      ,exportedElements
      ,allElements
      ,relativeVisibility
ORDER BY relativeVisibility DESC, allElements DESC, projectPath ASC, moduleName ASC