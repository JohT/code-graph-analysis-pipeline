// Return the first node with a centralityHyperlinkInducedTopicSearch(Authority/Hub) (HITS) if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityHyperlinkInducedTopicSearchAuthority IS NOT NULL
     AND codeUnit.centralityHyperlinkInducedTopicSearchHub       IS NOT NULL
  RETURN codeUnit.name                       AS shortCodeUnitName
        ,elementId(codeUnit)                 AS nodeElementId
        ,codeUnit.centralityHyperlinkInducedTopicSearchAuthority AS hyperlinkInducedTopicSearchAuthority
        ,codeUnit.centralityHyperlinkInducedTopicSearchHub       AS hyperlinkInducedTopicSearchHub
   LIMIT 1