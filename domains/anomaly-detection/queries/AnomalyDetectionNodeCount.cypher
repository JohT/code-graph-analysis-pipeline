// Count the number of nodes with dependencies. Variables: dependencies_projection_node, dependencies_projection_weight_property

 MATCH (source)-[dependency:DEPENDS_ON]->(target)
 WHERE $projection_node_label      IN labels(source)
   AND $projection_node_label      IN labels(target)
   AND $projection_weight_property IN keys(dependency)
  WITH collect(DISTINCT source.name) AS sources
      ,collect(DISTINCT target.name) AS targets
 UNWIND sources + targets AS source_or_target
RETURN count(DISTINCT source_or_target) AS node_count