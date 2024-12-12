// Read a property from projected nodes extended by some details. Variables: dependencies_projection, dependencies_projection_write_property. Requires "Add_file_name and_extension.cypher", "Set_localRootPath_for_modules", "Set_declaring_type_on_method_nodes".

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
OPTIONAL MATCH (project:Artifact|Project)-[:CONTAINS]->(codeUnit)
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnitNameWithDetails, codeUnit.fileName, codeUnit.name) AS codeUnitName
     ,codeUnit.name AS shortCodeUnitName
     ,propertyName
     ,propertyValue
     ,coalesce(codeUnit.communityLeidenId, 0)        AS communityId // optional, might be null
     ,coalesce(codeUnit.centralityPageRank, 0.00001) AS centrality // optional, might be null
     ,project.name AS owningProject