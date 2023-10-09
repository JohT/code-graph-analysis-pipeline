// Node Embeddings 1d using Fast Random Projection: Stream

CALL gds.fastRP.stream(
 $dependencies_projection + '-without-empty', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,relationshipWeightProperty: $dependencies_projection_weight_property
  }
)
YIELD nodeId, embedding
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,embedding
OPTIONAL MATCH (artifact:Artifact)-[:CONTAINS]->(codeUnit)
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
     ,coalesce(codeUnit.communityLeidenId, 0) AS communityId
     ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
     ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,embedding