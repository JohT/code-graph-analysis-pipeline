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
     ,coalesce(replace(last(split(codeUnit.fileName, '/')), '.jar', ''), codeUnit.name) AS shortCodeUnitName
     ,propertyName
     ,propertyValue
     ,coalesce(codeUnit.leidenCommunityId, 0) AS communityId
     ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
     ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName