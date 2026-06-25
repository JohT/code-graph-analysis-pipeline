// Set "projectName" property on SCIPType nodes using the module property set during import.

MATCH (n:SCIPType)
WHERE n.module IS NOT NULL
  AND n.projectName IS NULL
  SET n.projectName = n.module
RETURN count(*) AS updatedNodes
