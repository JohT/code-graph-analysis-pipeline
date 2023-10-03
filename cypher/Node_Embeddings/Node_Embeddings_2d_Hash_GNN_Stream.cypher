// Node Embeddings 2c using Hash GNN (Graph Neural Networks): Stream

CALL gds.beta.hashgnn.stream(
 $dependencies_projection + '-without-empty', {
     ,embeddingDensity: toInteger($dependencies_projection_embedding_dimension) * 2
     ,iterations: 3
     ,generateFeatures: {
         dimension: toInteger($dependencies_projection_embedding_dimension) * 4
        ,densityLevel: 1
     }
     ,outputDimension: toInteger($dependencies_projection_embedding_dimension)
  }
)
YIELD nodeId, embedding
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,embedding
OPTIONAL MATCH (artifact:Artifact)-[:CONTAINS]->(codeUnit)
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name) AS codeUnitName
     ,coalesce(codeUnit.leidenCommunityId, 0) AS communityId
     ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
     ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,embedding