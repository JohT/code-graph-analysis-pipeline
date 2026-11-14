// Add SemanticCodeIndexInternalType label to cross-file internal symbols of type kinds.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType IN ['Class', 'Interface', 'AbstractClass', 'Record', 'Struct', 'Enum', 'File', 'AnonymousClass']
  AND NOT n:SemanticCodeIndexInternalType
SET n:SemanticCodeIndexInternalType
RETURN count(*) AS labelledNodes
