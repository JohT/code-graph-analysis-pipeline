// Delete Relationship "SIMILAR"

MATCH (source)-[similarity:SIMILAR]->(target) 
 WHERE $dependencies_projection_node IN labels(source)
   AND $dependencies_projection_node IN labels(target)
DELETE similarity