// Centrality Label Delete

  CALL db.labels() YIELD label
 WHERE label = 'Mark4Top' + apoc.text.capitalize($dependencies_projection_write_property)
  WITH collect(label) AS selectedLabels
 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member) 
   AND member[$dependencies_projection_write_property] IS NOT NULL
  WITH collect(member) AS members, selectedLabels
  CALL apoc.create.removeLabels(members, selectedLabels) YIELD node
RETURN COUNT(node) AS nodesCount;