// List nodes that have both codeUnit embedding properties and community or centrality properties set.
// Reads embeddingsFastRandomProjection, communityLeidenId, centralityPageRank written by nodeEmbeddingsCsv.sh and graphAlgorithmsCsv.sh.

 MATCH (codeUnit)
 WHERE codeUnit.embeddingsFastRandomProjection IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS nodeName
      ,size(codeUnit.embeddingsFastRandomProjection)            AS embeddingDimensions
      ,codeUnit.communityLeidenId                               AS communityLeidenId
      ,codeUnit.centralityPageRank                              AS pageRankScore
ORDER BY codeUnit.centralityPageRank DESCENDING
LIMIT 10