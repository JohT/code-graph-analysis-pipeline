// List the top nodes by ArticleRank centrality score. Reads the centralityArticleRank property written by centralityCsv.sh.
// Filters to relevant node labels, excluding Mark4* metrics and infrastructure labels.

MATCH (codeUnit)
WHERE codeUnit.centralityArticleRank IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS nodeName
      ,codeUnit.centralityArticleRank                           AS articleRankScore
ORDER BY codeUnit.centralityArticleRank DESCENDING
LIMIT 30
