// Read a property from the projection. Variables: dependencies_projection, dependencies_projection_write_property

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-without-empty'
    ,[$dependencies_projection_write_property]
)
YIELD nodeId, nodeProperty, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,nodeProperty            AS propertyName
     ,propertyValue
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name)                AS codeUnitName
     ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', '')) AS shortCodeUnitName
     ,propertyName
     ,propertyValue