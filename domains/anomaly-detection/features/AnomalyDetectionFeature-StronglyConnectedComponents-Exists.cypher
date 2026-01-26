// Return the first node with a "communityStronglyConnectedComponentId" if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityStronglyConnectedComponentId       IS NOT NULL
  RETURN codeUnit.name                                        AS shortCodeUnitName
        ,elementId(codeUnit)                                  AS nodeElementId
        ,codeUnit.communityStronglyConnectedComponentId       AS communityStronglyConnectedComponentId
   LIMIT 1