// Read a property from the projection. Variables: dependencies_projection, dependencies_projection_write_property. Requires "Add_file_name and_extension.cypher".

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-cleaned'
    ,[$dependencies_projection_write_property]
)
YIELD nodeId, nodeProperty, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,nodeProperty            AS propertyName
     ,propertyValue
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
     ,codeUnit.name      AS shortCodeUnitName
     ,propertyName
     ,propertyValue