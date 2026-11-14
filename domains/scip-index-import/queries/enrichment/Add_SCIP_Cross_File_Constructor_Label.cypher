// Add SemanticCodeIndexConstructor label to cross-file internal symbols of constructor kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'Constructor'
  AND NOT n:SemanticCodeIndexConstructor
SET n:SemanticCodeIndexConstructor
RETURN count(*) AS labelledNodes
