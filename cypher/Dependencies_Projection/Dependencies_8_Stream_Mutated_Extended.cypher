// Read a property from the projection into the Graph. Variables: dependencies_projection, dependencies_projection_write_property

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-without-empty'
    ,[$dependencies_projection_write_property]
)
YIELD nodeId, nodeProperty, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,nodeProperty AS propertyName
     ,propertyValue
OPTIONAL MATCH (artifact:Artifact)-[:CONTAINS]->(codeUnit)
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS codeUnitName
     ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', '')) AS shortCodeUnitName
     ,propertyName
     ,propertyValue
     ,coalesce(codeUnit.communityLeidenId, 0) AS communityId // optional, might be null
     ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality // optional, might be null
     ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS owningArtifactName