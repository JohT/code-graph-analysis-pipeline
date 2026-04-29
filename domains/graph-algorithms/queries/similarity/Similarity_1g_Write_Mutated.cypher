// Write the Similarity relationship from the projection into the Graph. Variables: dependencies_projection, dependencies_projection_write_property

CALL gds.graph.relationship.write(
   $dependencies_projection + '-cleaned'
  ,'SIMILAR'
  ,'score'
)
 YIELD relationshipsWritten, propertiesWritten, writeMillis
RETURN relationshipsWritten, propertiesWritten, writeMillis