// Return the first node with a "maxDistanceFromSource" if it exists

MATCH (codeUnit)
 WHERE codeUnit.maxDistanceFromSource IS NOT NULL
   AND codeUnit.topologicalSortIndex  IS NOT NULL
   AND $dependencies_projection_node  IN LABELS(codeUnit) 
RETURN codeUnit.name                                       AS shortCodeUnitName
      ,elementId(codeUnit)                                 AS nodeElementId
      ,codeUnit.maxDistanceFromSource                      AS maxDistanceFromSource
LIMIT 1