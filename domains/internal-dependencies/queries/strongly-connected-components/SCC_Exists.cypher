// Return first node with communityStronglyConnectedComponentId if it exists

MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
RETURN codeUnit.name AS shortCodeUnitName
      ,elementId(codeUnit) AS nodeElementId
      ,codeUnit.communityStronglyConnectedComponentId AS sccId
LIMIT 1
