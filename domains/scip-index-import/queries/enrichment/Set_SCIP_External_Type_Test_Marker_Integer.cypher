// Set testMarkerInteger on SCIP external type nodes based on the isTest property set during import. Requires "Import_SCIP_Type_External_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexExternalType)
WHERE n.testMarkerInteger IS NULL
  SET n.testMarkerInteger = CASE WHEN n.isTest THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
