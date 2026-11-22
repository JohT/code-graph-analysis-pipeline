// Return the first node with a communityStronglyConnectedComponentId property (indicating SCC analysis has completed). Parameterized by node label ($dependencies_projection_node).

MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
RETURN codeUnit.name AS shortCodeUnitName
      ,elementId(codeUnit) AS nodeElementId
      ,codeUnit.communityStronglyConnectedComponentId AS communityStronglyConnectedComponentId
LIMIT 1
