// List the top nodes by PageRank centrality score. Reads the centralityPageRank property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.centralityPageRank IS NOT NULL
RETURN labels(node)       AS nodeLabels
      ,coalesce(node.fqn, node.fileName, node.name) AS nodeName
      ,node.centralityPageRank                       AS pageRankScore
ORDER BY node.centralityPageRank DESCENDING
LIMIT 30
