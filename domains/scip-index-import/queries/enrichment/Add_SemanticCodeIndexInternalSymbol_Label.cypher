// Add :SemanticCodeIndexInternalSymbol label to all SemanticCodeIndexInternalType, SemanticCodeIndexFunction, and SemanticCodeIndexVariable nodes, unifying them for cross-entity queries. Requires "Import_SCIP_Type_Internal_Nodes.cypher", "Import_SCIP_Function_Nodes.cypher", and "Import_SCIP_Variable_Nodes.cypher".

MATCH (n:SCIP)
WHERE n:SemanticCodeIndexInternalType OR n:SemanticCodeIndexFunction OR n:SemanticCodeIndexVariable
SET n:SemanticCodeIndexInternalSymbol
RETURN count(*) AS labeledNodes
