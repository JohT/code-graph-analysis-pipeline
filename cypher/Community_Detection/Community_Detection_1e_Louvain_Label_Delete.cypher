// Community Detection Louvain Label Delete

  CALL db.labels() YIELD label
 WHERE label STARTS WITH $dependencies_projection_node + "Louvain"
  WITH collect(label) AS selectedLabels
 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member) 
   AND member.louvainCommunityId IS NOT NULL
  WITH collect(member) AS members, selectedLabels
  CALL apoc.create.removeLabels(members, selectedLabels) YIELD node
RETURN COUNT(node) AS nodesCount;