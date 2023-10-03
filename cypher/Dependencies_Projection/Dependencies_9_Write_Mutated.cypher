// Write a property from the projection into the Graph. Variables: dependencies_projection, dependencies_projection_write_property

CALL gds.graph.nodeProperties.write(
   $dependencies_projection + '-without-empty'
  ,[$dependencies_projection_write_property]
)
 YIELD propertiesWritten, nodeProperties, writeMillis
RETURN propertiesWritten, nodeProperties, writeMillis