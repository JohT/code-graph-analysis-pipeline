// Prepare projection by e.g. filling in default values for missing properties

 MATCH (source)-[DEPENDS_ON]->(target)
 WHERE $dependencies_projection_node IN labels(source)
   AND $dependencies_projection_node IN labels(target)
   SET source.testMarkerInteger = coalesce(source.testMarkerInteger, 0)
      ,target.testMarkerInteger = coalesce(target.testMarkerInteger, 0)
RETURN count(*) AS numberOfDependencies