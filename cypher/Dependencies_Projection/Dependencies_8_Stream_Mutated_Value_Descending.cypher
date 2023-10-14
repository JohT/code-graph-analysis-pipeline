// Read a property from the projection and order it by its value descending. Variables: dependencies_projection, dependencies_projection_write_property

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-cleaned'
    ,[$dependencies_projection_write_property]
)
YIELD nodeId, nodeProperty, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,nodeProperty            AS propertyName
     ,propertyValue
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
     ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', ''))      AS shortCodeUnitName
     ,propertyName
     ,propertyValue
ORDER BY propertyValue DESCENDING, codeUnitName ASCENDING