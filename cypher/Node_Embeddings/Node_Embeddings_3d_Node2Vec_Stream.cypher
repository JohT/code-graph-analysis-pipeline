// Node Embeddings 3c using Node2Vec: Stream

CALL gds.node2vec.stream(
 $dependencies_projection + '-cleaned', {
     ,embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,iterations: 3
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