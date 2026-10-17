// Calculate and set abstractness for SCIP internal types and return the distribution.

MATCH (n:SemanticCodeIndexInternalType)
 WITH n
     ,CASE WHEN n.isAbstract THEN 1.0 ELSE 0.0 END AS abstractness
  SET n.abstractness = abstractness
RETURN abstractness
      ,count(*) AS typeCount
      ,collect(n.name)[0..4] AS examples
ORDER BY abstractness ASC
