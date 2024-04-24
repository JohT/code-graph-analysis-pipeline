// Check if there is at least one projectable dependency. Variables: dependencies_projection_node, dependencies_projection_weight_property

 MATCH (source)-[dependency:DEPENDS_ON]->(target)
 WHERE $dependencies_projection_node            IN labels(source)
   AND $dependencies_projection_node            IN labels(target)
   AND $dependencies_projection_weight_property IN keys(dependency)
RETURN elementId(source) AS sourceElementId
 LIMIT 1