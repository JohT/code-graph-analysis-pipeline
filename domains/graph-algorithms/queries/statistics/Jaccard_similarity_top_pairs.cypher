// List the top most similar node pairs by Jaccard similarity score. Reads the SIMILAR relationship written by similarityCsv.sh.
// Filters to relevant node labels, excluding Mark4* metrics and infrastructure labels.

MATCH (source)-[similarity:SIMILAR]->(target)
UNWIND labels(source) AS sourceLabel
  WITH *
 WHERE NOT sourceLabel STARTS WITH 'Mark4'
   AND NOT sourceLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(sourceLabel) AS sourceNodeLabels
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceNodeName
      ,similarity
      ,target
UNWIND labels(target) AS targetLabel
  WITH *
 WHERE NOT targetLabel STARTS WITH 'Mark4'
   AND NOT targetLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(targetLabel) AS targetNodeLabels
      ,sourceNodeLabels
      ,sourceNodeName
      ,target
      ,similarity
RETURN sourceNodeLabels
      ,sourceNodeName
      ,targetNodeLabels
      ,coalesce(target.fqn, target.fileName, target.name) AS targetNodeName
      ,similarity.score                                   AS similarityScore
ORDER BY similarity.score DESCENDING
LIMIT 30
