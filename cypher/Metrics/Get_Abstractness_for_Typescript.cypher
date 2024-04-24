// Get Typscript Modules with the lowest abstractness first (if set before)

MATCH (module:TS:Module)
WHERE module.abstractness IS NOT NULL 
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(module)
RETURN reverse(split(reverse(projectdir.absoluteFileName), '/')[0]) AS projectName
      ,module.globalFqn           AS fullQualifiedModuleName
      ,module.name                AS moduleName
      ,module.abstractness        AS abstractness
      ,module.numberAbstractTypes AS numberAbstractTypes
      ,module.numberTypes         AS numberTypes
ORDER BY abstractness ASC, numberTypes DESC