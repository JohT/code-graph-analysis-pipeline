// Overview of node embedding properties in the graph. Shows which embedding properties are set and how many nodes have them.
// Reads embeddingsFastRandomProjection, embeddingsHashGNN, embeddingsNode2Vec properties written by nodeEmbeddingsCsv.sh.

MATCH (node)
WHERE node.embeddingsFastRandomProjection IS NOT NULL
   OR node.embeddingsHashGNN IS NOT NULL
   OR node.embeddingsNode2Vec IS NOT NULL
RETURN labels(node)                                                         AS nodeLabels
      ,count(*)                                                              AS nodeCount
      ,count(node.embeddingsFastRandomProjection)                            AS fastRandomProjectionCount
      ,count(node.embeddingsHashGNN)                                         AS hashGNNCount
      ,count(node.embeddingsNode2Vec)                                        AS node2VecCount
      ,size(coalesce(node.embeddingsFastRandomProjection, []))                AS fastRandomProjectionDimensions
      ,size(coalesce(node.embeddingsHashGNN, []))                             AS hashGNNDimensions
      ,size(coalesce(node.embeddingsNode2Vec, []))                            AS node2VecDimensions
ORDER BY nodeCount DESCENDING
LIMIT 20
