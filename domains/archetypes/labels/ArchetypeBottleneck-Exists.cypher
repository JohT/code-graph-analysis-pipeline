// Return the first node with an archetypeBottleneckRank if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.archetypeBottleneckRank IS NOT NULL
  RETURN codeUnit.name                   AS shortCodeUnitName
        ,elementId(codeUnit)             AS nodeElementId
        ,codeUnit.archetypeBottleneckRank AS archetypeBottleneckRank
   LIMIT 1
