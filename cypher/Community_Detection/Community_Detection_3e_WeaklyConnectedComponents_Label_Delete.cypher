// Community Detection Leiden Label Delete

  CALL db.labels() YIELD label
 WHERE label STARTS WITH $dependencies_projection_node + "WeaklyConnectedComponent"
  WITH collect(label) AS selectedLabels
 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member) 
   AND member.weaklyConnectedComponentId IS NOT NULL
  WITH collect(member) AS members, selectedLabels
  CALL apoc.create.removeLabels(members, selectedLabels) YIELD node
RETURN COUNT(node) AS nodesCount;