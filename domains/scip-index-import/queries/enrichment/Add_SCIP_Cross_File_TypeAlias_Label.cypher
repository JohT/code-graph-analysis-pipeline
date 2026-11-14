// Add SemanticCodeIndexTypeAlias label to cross-file internal symbols of type alias kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'TypeAlias'
  AND NOT n:SemanticCodeIndexTypeAlias
SET n:SemanticCodeIndexTypeAlias
RETURN count(*) AS labelledNodes
