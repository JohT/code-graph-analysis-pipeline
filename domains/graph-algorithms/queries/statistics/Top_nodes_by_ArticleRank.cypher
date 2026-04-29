// List the top nodes by ArticleRank centrality score. Reads the centralityArticleRank property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.centralityArticleRank IS NOT NULL
RETURN labels(node)       AS nodeLabels
      ,coalesce(node.fqn, node.fileName, node.name) AS nodeName
      ,node.centralityArticleRank                    AS articleRankScore
ORDER BY node.centralityArticleRank DESCENDING
LIMIT 30
