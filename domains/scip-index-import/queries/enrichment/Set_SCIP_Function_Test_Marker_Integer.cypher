// Set testMarkerInteger on SCIP function nodes based on the isTest property set during import. Requires "Import_SCIP_Function_Nodes.cypher".

MATCH (n:SCIP&SemanticCodeIndexFunction)
WHERE n.testMarkerInteger IS NULL
  SET n.testMarkerInteger = CASE WHEN n.isTest THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
