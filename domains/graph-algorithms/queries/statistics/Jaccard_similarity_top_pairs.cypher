// List the top most similar node pairs by Jaccard similarity score. Reads the SIMILAR relationship written by graphAlgorithmsCsv.sh.

MATCH (source)-[similarity:SIMILAR]->(target)
RETURN labels(source)     AS sourceNodeLabels
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceNodeName
      ,labels(target)     AS targetNodeLabels
      ,coalesce(target.fqn, target.fileName, target.name) AS targetNodeName
      ,similarity.score   AS similarityScore
ORDER BY similarity.score DESCENDING
LIMIT 30
