// Read a property from projected nodes. Variables: dependencies_projection, dependencies_projection_write_property. Requires "Add_file_name and_extension.cypher", "Set_localRootPath_for_modules", "Set_declaring_type_on_method_nodes".

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-cleaned'
    ,[$dependencies_projection_write_property]
)
YIELD nodeId, nodeProperty, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,nodeProperty            AS propertyName
     ,propertyValue
  WITH *, coalesce(codeUnit.declaringType + ': ', '')  +
          coalesce(codeUnit.rootProjectName + '/', '') +
          coalesce(codeUnit.signature,  codeUnit.name) AS codeUnitNameWithDetails
 WITH propertyName
     ,propertyValue
     ,coalesce(codeUnit.fqn, codeUnitNameWithDetails, codeUnit.fileName, codeUnit.name) AS codeUnitName
     ,codeUnit.name AS shortCodeUnitName
 WITH propertyName
     ,propertyValue
     ,collect(DISTINCT codeUnitName)      AS codeUnitNames
     ,collect(DISTINCT shortCodeUnitName) AS shortCodeUnitNames
RETURN propertyName, propertyValue, size(codeUnitNames) AS codeUnits, codeUnitNames, shortCodeUnitNames