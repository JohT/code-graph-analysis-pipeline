// Centrality Summary. Requires "Add_file_name and_extension.cypher".

MATCH (codeUnit)
WHERE (codeUnit.incomingDependencies > 0 OR codeUnit.outgoingDependencies > 0)
  AND $dependencies_projection_node IN LABELS(codeUnit) 
RETURN coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name)      AS name
      ,codeUnit.name AS shortName
      ,codeUnit.centralityPageRank                  AS pageRank
      ,codeUnit.centralityArticleRank               AS articleRank
      ,codeUnit.centralityBetweenness               AS betweenness
      ,codeUnit.centralityCostEffectiveLazyForward  AS costEffectiveLazyForward                   
      ,codeUnit.centralityHarmonic                  AS harmonicCloseness
      ,codeUnit.centralityCloseness                 AS closeness
      ,codeUnit.centralityHyperlinkInducedTopicSearchAuthority AS hyperlinkInducedTopicSearchAuthority
      ,codeUnit.centralityHyperlinkInducedTopicSearchHub       AS hyperlinkInducedTopicSearchHub
      ,codeUnit.incomingDependencies                AS incomingDependencies
      ,codeUnit.outgoingDependencies                AS outgoingDependencies