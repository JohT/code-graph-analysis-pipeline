// List the top nodes by PageRank centrality score. Reads the centralityPageRank property written by centralityCsv.sh.
// Filters to relevant node labels, excluding Mark4* metrics and infrastructure labels.

MATCH (codeUnit)
WHERE codeUnit.centralityPageRank IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS nodeName
      ,codeUnit.centralityPageRank                              AS pageRankScore
ORDER BY codeUnit.centralityPageRank DESCENDING
LIMIT 30
