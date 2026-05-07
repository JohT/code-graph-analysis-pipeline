// Return the first node with a "communityWeaklyConnectedComponentId" if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityWeaklyConnectedComponentId       IS NOT NULL
  RETURN codeUnit.name                                      AS shortCodeUnitName
        ,elementId(codeUnit)                                AS nodeElementId
        ,codeUnit.communityWeaklyConnectedComponentId       AS communityWeaklyConnectedComponentId
   LIMIT 1