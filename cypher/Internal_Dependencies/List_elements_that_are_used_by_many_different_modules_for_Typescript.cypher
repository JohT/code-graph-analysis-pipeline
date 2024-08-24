// List elements that are used by many different modules

MATCH (sourceModule:TS&Module&!TestRelated)-[:EXPORTS]->(sourceElement:TS)
MATCH (sourceElement)-[:DEPENDS_ON]->(dependentElement:TS&!Module&!ExternalModule)
MATCH (dependentModule:TS&Module&!TestRelated)-[:EXPORTS]->(dependentElement)
WHERE sourceModule <> dependentModule
 WITH dependentElement
     ,labels(dependentElement)               AS dependentElementLabels
     ,COUNT(DISTINCT sourceModule.globalFqn) AS numberOfUsingModules
UNWIND dependentElementLabels AS dependentElementLabel
  WITH *
 WHERE NOT dependentElementLabel = 'TS' // Filter out generic TS label
RETURN dependentElement.globalFqn            AS fullQualifiedDependentElementName
      ,dependentElement.moduleName           AS dependentElementModuleName
      ,dependentElement.name                 AS dependentElementName
      ,dependentElementLabel                 AS dependentElementLabels
      ,numberOfUsingModules
 ORDER BY numberOfUsingModules DESC, dependentElementName ASC