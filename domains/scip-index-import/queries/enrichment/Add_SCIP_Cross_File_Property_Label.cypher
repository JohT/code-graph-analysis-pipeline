// Add SemanticCodeIndexProperty label to cross-file internal symbols of property kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'Property'
  AND NOT n:SemanticCodeIndexProperty
SET n:SemanticCodeIndexProperty
RETURN count(*) AS labelledNodes
