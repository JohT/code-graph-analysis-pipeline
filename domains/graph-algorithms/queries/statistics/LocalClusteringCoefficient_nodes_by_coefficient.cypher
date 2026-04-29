// List the top nodes by Local Clustering Coefficient. Reads the communityLocalClusteringCoefficient property written by communityCsv.sh.
// Filters to relevant node labels, excluding Mark4* metrics and infrastructure labels.

MATCH (codeUnit)
WHERE codeUnit.communityLocalClusteringCoefficient IS NOT NULL
UNWIND labels(codeUnit) AS nodeLabel
  WITH *
 WHERE NOT nodeLabel STARTS WITH 'Mark4'
   AND NOT nodeLabel IN ['File', 'Directory', 'ByteCode', 'ConnectedInternalJavaType', 'InternalJavaType']
  WITH collect(nodeLabel) AS nodeLabels
      ,codeUnit
RETURN nodeLabels
      ,coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS nodeName
      ,codeUnit.communityLocalClusteringCoefficient             AS localClusteringCoefficient
ORDER BY codeUnit.communityLocalClusteringCoefficient DESCENDING
LIMIT 30
