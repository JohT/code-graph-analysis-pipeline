// Set "projectName" property on SemanticCodeIndexType nodes using the module property set during import.

MATCH (n:SemanticCodeIndexType)
WHERE n.module IS NOT NULL
  AND n.projectName IS NULL
  SET n.projectName = n.module
RETURN count(*) AS updatedNodes
