// Add SemanticCodeIndexInternalExecutable label to kind-level internal function symbols. This is a stable aggregated label for runtime executable code. Requires "Import_SCIP_Function_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexFunction)
WHERE NOT n:SemanticCodeIndexInternalExecutable
SET n:SemanticCodeIndexInternalExecutable
RETURN count(*) AS labelledNodes
