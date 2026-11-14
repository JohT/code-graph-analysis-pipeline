// Add SemanticCodeIndexFunction label to cross-file internal symbols of function kinds.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType IN ['Function', 'Method']
  AND NOT n:SemanticCodeIndexFunction
SET n:SemanticCodeIndexFunction
RETURN count(*) AS labelledNodes
