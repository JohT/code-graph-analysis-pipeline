// Calculate and set abstractness for SCIP modules and return a 0.1 ranged bin distribution.

MATCH (m:SemanticCodeIndexModule)
 WITH m
     ,count{(m)-[:CONTAINS]->(:SemanticCodeIndexInternalType)}                    AS numberTypes
     ,count{(m)-[:CONTAINS]->(:SemanticCodeIndexInternalType {isAbstract: true})} AS numberAbstractTypes
 WITH *
     ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET m.abstractness = abstractness
RETURN round(abstractness, 1)  AS abstractnessBin
      ,count(*)                AS packageCount
      ,collect(m.name)[0..4]   AS examples
ORDER BY abstractnessBin ASC
