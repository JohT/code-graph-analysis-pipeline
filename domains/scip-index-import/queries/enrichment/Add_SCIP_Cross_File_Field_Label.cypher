// Add SemanticCodeIndexField label to cross-file internal symbols of field kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'Field'
  AND NOT n:SemanticCodeIndexField
SET n:SemanticCodeIndexField
RETURN count(*) AS labelledNodes
