//Calculate and set Abstractness for TypeScript Modules.

MATCH (module:TS:Module)
  WITH module
      ,count{(module)-[:EXPORTS]->(:TS)}                    AS numberTypes
      ,count{(module)-[:EXPORTS]->(:Class{abstract:true})}  AS numberAbstractClasses
      ,count{(module)-[:EXPORTS]->(:TypeAlias)}             AS numberTypeAliases
      ,count{(module)-[:EXPORTS]->(:Interface)}             AS numberInterfaces
  WITH *
      ,numberInterfaces + numberTypeAliases + (numberAbstractClasses * 0.7) AS numberAbstractTypes
  WITH *
      ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38) AS abstractness
   SET module.abstractness          = abstractness
RETURN round(abstractness, 1)       AS abstractnessBin
      ,count(*)                     AS packageCount
      ,collect(module.name)[0..4]   AS examples
ORDER BY abstractnessBin ASC