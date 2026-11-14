// Add SemanticCodeIndexGetter label to cross-file internal symbols of getter kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'Getter'
  AND NOT n:SemanticCodeIndexGetter
SET n:SemanticCodeIndexGetter
RETURN count(*) AS labelledNodes
