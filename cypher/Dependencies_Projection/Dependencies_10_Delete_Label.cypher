// Community Detection Label Propagation Label Delete

  CALL db.labels() YIELD label
 WHERE label STARTS WITH 'Mark4' + $dependencies_projection_node + $dependencies_projection_write_label
  WITH collect(label) AS selectedLabels
 MATCH (member)
 WHERE $dependencies_projection_node IN labels(member) 
   AND member[$dependencies_projection_write_property] IS NOT NULL
  WITH collect(member) AS members, selectedLabels
  CALL apoc.create.removeLabels(members, selectedLabels) YIELD node
RETURN COUNT(node) AS nodesCount;