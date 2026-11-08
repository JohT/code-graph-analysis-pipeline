// Add :SemanticCodeIndexInternalSymbol label to all SemanticCodeIndexInternalType and SemanticCodeIndexFunction nodes, unifying them for cross-entity queries. Requires "Import_SCIP_Type_Internal_Nodes.cypher" and "Import_SCIP_Function_Nodes.cypher".

MATCH (n:SCIP)
WHERE n:SemanticCodeIndexInternalType OR n:SemanticCodeIndexFunction
SET n:SemanticCodeIndexInternalSymbol
RETURN count(*) AS labeledNodes
