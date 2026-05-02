// List the top nodes by Betweenness centrality score. Reads the centralityBetweenness property written by centralityCsv.sh.
// Filters to relevant node labels, excluding Mark4* metrics and infrastructure labels.

MATCH (codeUnit)
WHERE codeUnit.centralityBetweenness IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS nodeName
      ,codeUnit.centralityBetweenness                           AS betweennessScore
ORDER BY codeUnit.centralityBetweenness DESCENDING
LIMIT 30
