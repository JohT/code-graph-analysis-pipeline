// Write a property from the projection into the Graph. Variables: dependencies_projection, dependencies_projection_write_property

 MATCH (member)
 WHERE member[$dependencies_projection_write_property] IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member) 
  WITH collect(member)            AS members
      ,count(DISTINCT member)     AS memberCount
      ,$dependencies_projection_node + $dependencies_projection_write_label + toString(member[$dependencies_projection_write_property]) AS labelName
 WHERE memberCount > 1
UNWIND members AS member
  CALL apoc.create.addLabels(member, [labelName]) YIELD node
RETURN count(node) AS nodesCount