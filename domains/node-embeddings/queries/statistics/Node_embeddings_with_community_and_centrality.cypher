// List nodes that have both node embedding properties and community or centrality properties set.
// Reads embeddingsFastRandomProjection, communityLeidenId, centralityPageRank written by nodeEmbeddingsCsv.sh and graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.embeddingsFastRandomProjection IS NOT NULL
RETURN labels(node)                                                              AS nodeLabels
      ,coalesce(node.fqn, node.fileName, node.name)                              AS nodeName
      ,size(node.embeddingsFastRandomProjection)                                  AS embeddingDimensions
      ,node.communityLeidenId                                                     AS communityLeidenId
      ,node.centralityPageRank                                                    AS pageRankScore
ORDER BY node.centralityPageRank DESCENDING
LIMIT 30
