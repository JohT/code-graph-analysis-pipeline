// Add SemanticCodeIndexEnumMember label to cross-file internal symbols of enum member kind.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType = 'EnumMember'
  AND NOT n:SemanticCodeIndexEnumMember
SET n:SemanticCodeIndexEnumMember
RETURN count(*) AS labelledNodes
