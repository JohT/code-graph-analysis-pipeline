// Set "projectName" property on SemanticCodeIndexFunction nodes using the module property set during import. Only set if projectName is not already defined to preserve any intentional custom values.

MATCH (n:SCIP&SemanticCodeIndexFunction)
WHERE n.module IS NOT NULL AND n.projectName IS NULL
SET n.projectName = n.module
RETURN count(*) AS updatedNodes
