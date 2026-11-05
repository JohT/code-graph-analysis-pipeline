// Calculate and set abstractness for SCIP internal symbols (types and functions) and return the distribution.

MATCH (n:SemanticCodeIndexInternalSymbol)
 WITH n
     ,CASE WHEN n.isAbstract THEN 1.0 ELSE 0.0 END AS abstractness
  SET n.abstractness = abstractness
RETURN abstractness
      ,count(*) AS symbolCount
      ,collect(n.name)[0..4] AS examples
ORDER BY abstractness ASC
