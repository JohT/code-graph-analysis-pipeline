// Overview of codeUnit node embedding properties in the graph. Shows which embedding properties are set and how many nodes have them.
// Reads embeddingsFastRandomProjection, embeddingsHashGNN, embeddingsNode2Vec properties written by nodeEmbeddingsCsv.sh.

 MATCH (codeUnit)
 WHERE codeUnit.embeddingsFastRandomProjection IS NOT NULL
    OR codeUnit.embeddingsHashGNN IS NOT NULL
    OR codeUnit.embeddingsNode2Vec IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,count(*)                                                    AS nodeCount
      ,count(codeUnit.embeddingsFastRandomProjection)              AS fastRandomProjectionCount
      ,count(codeUnit.embeddingsHashGNN)                           AS hashGNNCount
      ,count(codeUnit.embeddingsNode2Vec)                          AS node2VecCount
      ,size(coalesce(codeUnit.embeddingsFastRandomProjection, [])) AS fastRandomProjectionDimensions
      ,size(coalesce(codeUnit.embeddingsHashGNN, []))              AS hashGNNDimensions
      ,size(coalesce(codeUnit.embeddingsNode2Vec, []))             AS node2VecDimensions
ORDER BY nodeCount DESCENDING
LIMIT 10
