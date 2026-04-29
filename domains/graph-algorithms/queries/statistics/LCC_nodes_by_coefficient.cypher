// List the top nodes by Local Clustering Coefficient. Reads the communityLocalClusteringCoefficient property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.communityLocalClusteringCoefficient IS NOT NULL
RETURN labels(node)       AS nodeLabels
      ,coalesce(node.fqn, node.fileName, node.name) AS nodeName
      ,node.communityLocalClusteringCoefficient      AS localClusteringCoefficient
ORDER BY node.communityLocalClusteringCoefficient DESCENDING
LIMIT 30
