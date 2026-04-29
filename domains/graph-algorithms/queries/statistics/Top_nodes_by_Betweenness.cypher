// List the top nodes by Betweenness centrality score. Reads the centralityBetweenness property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.centralityBetweenness IS NOT NULL
RETURN labels(node)       AS nodeLabels
      ,coalesce(node.fqn, node.fileName, node.name) AS nodeName
      ,node.centralityBetweenness                    AS betweennessScore
ORDER BY node.centralityBetweenness DESCENDING
LIMIT 30
