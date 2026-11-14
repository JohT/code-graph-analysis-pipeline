// Add SemanticCodeIndexVariable label to cross-file internal symbols of variable kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'Variable'
  AND NOT n:SemanticCodeIndexVariable
SET n:SemanticCodeIndexVariable
RETURN count(*) AS labelledNodes
