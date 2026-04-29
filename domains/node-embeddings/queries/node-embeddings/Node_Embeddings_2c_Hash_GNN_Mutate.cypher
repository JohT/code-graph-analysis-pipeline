// Node Embeddings 2b using Hash GNN (Graph Neural Networks): Mutate

CALL gds.beta.hashgnn.mutate(
 $dependencies_projection + '-cleaned', {
      embeddingDensity: toInteger($dependencies_projection_embedding_dimension) * 2
     ,iterations: 3
     ,generateFeatures: {
         dimension: toInteger($dependencies_projection_embedding_dimension) * 4
        ,densityLevel: 3
     }
     ,outputDimension: toInteger($dependencies_projection_embedding_dimension)
     ,neighborInfluence: 0.9
     ,randomSeed: 30
     ,mutateProperty: $dependencies_projection_write_property
  }
)
 YIELD nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, mutateMillis
RETURN nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, mutateMillis