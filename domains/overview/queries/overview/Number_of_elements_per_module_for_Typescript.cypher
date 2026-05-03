// Number of elements per module for Typescript

 MATCH (module:TS:Module)-[:EXPORTS]->(element:TS)
 OPTIONAL MATCH (module)<-[:CONTAINS]-(project:TS:Project)-[:HAS_ROOT]->(projectRoot:Directory)
  WITH module.name      AS moduleName
      ,replace(module.globalFqn, 
               coalesce(projectRoot.absoluteFileName + '/', ''),
               '')               AS modulePath
      ,module.globalFqn          AS fullQualifiedModuleName
      ,count(DISTINCT element)   AS numberOfModuleElements
      ,collect(DISTINCT element) AS moduleElements
UNWIND moduleElements AS element
  WITH moduleName
      ,modulePath
      ,fullQualifiedModuleName
      ,numberOfModuleElements
      ,element
      ,labels(element) AS elementLabels
UNWIND elementLabels AS typeLabel
  WITH moduleName
      ,modulePath
      ,fullQualifiedModuleName
      ,numberOfModuleElements
      ,element
      ,typeLabel
 WHERE NOT typeLabel IN ['TS', 'ExternalDeclaration']
RETURN moduleName
      ,modulePath
      ,fullQualifiedModuleName
      ,numberOfModuleElements
      ,typeLabel       AS languageElement
      ,count(element)  AS numberOfElements
 ORDER BY numberOfModuleElements DESC, moduleName ASC