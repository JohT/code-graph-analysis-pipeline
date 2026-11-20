// Add SemanticCodeIndexExternalType label to external symbols of type kinds.
// Requires "Import_SCIP_Cross_File_External_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexExternalSymbol)
WHERE n.symbolType IN ['Class', 'Interface', 'AbstractClass', 'Record', 'Struct', 'Enum', 'TypeAlias', 'Unknown']
  AND NOT n:SemanticCodeIndexExternalType
SET n:SemanticCodeIndexExternalType
RETURN count(*) AS labelledNodes
