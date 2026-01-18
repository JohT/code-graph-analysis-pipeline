//Calculate and set Abstractness for Typescript Modules

MATCH (module:TS:Module)
// Get the project of the external module if available
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(module)
  WITH reverse(split(reverse(projectdir.absoluteFileName), '/')[0]) AS projectName
      ,module
      ,count{(module)-[:EXPORTS]->(:TS)}                    AS numberTypes
      ,count{(module)-[:EXPORTS]->(:Class{abstract:true})}  AS numberAbstractClasses
      ,count{(module)-[:EXPORTS]->(:TypeAlias)}             AS numberTypeAliases
      ,count{(module)-[:EXPORTS]->(:Interface)}             AS numberInterfaces
  WITH *
      ,numberInterfaces + numberTypeAliases +  numberAbstractClasses        AS numberAbstractTypes
      ,numberInterfaces + numberTypeAliases + (numberAbstractClasses * 0.7) AS weightedAbstractTypes
  WITH *
      ,toFloat(weightedAbstractTypes) / (numberTypes + 1E-38) AS abstractness
   SET module.abstractness            = abstractness
      ,module.numberOfAbstractTypes   = numberAbstractTypes
      ,module.numberOfAbstractClasses = numberAbstractClasses
      ,module.numberOfTypes           = numberTypes
RETURN projectName
      ,module.globalFqn  AS fullQualifiedModuleName
      ,module.name       AS moduleName
      ,abstractness
      ,numberAbstractTypes
      ,numberTypes
      ,numberAbstractClasses
      ,weightedAbstractTypes
ORDER BY abstractness ASC, numberTypes DESC