// Set testMarkerInteger on SCIP symbol nodes based on the isTest property set during import. Requires "Import_SCIP_*_Nodes.cypher".

MATCH (n:SCIP&SemanticCodeIndexInternalSymbol)
WHERE n.testMarkerInteger IS NULL
  SET n.testMarkerInteger = CASE WHEN n.isTest THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
