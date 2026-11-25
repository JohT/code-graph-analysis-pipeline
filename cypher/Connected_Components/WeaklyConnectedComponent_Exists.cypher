// Return first node with communityWeaklyConnectedComponentId if it exists

MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityWeaklyConnectedComponentId IS NOT NULL
RETURN codeUnit.name AS shortCodeUnitName
      ,elementId(codeUnit) AS nodeElementId
      ,codeUnit.communityWeaklyConnectedComponentId AS communityWeaklyConnectedComponentId
LIMIT 1
