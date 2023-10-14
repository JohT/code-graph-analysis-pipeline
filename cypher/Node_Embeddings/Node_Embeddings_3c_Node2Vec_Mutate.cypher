// Node Embeddings 3c using Node2Vec: Mutate

CALL gds.node2vec.mutate(
 $dependencies_projection + '-cleaned', {
     ,embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,iterations: 3
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,mutateProperty: $dependencies_projection_write_property
  }
)
 YIELD nodePropertiesWritten, lossPerIteration, nodeCount, preProcessingMillis, computeMillis, mutateMillis
RETURN nodePropertiesWritten, lossPerIteration, nodeCount, preProcessingMillis, computeMillis, mutateMillis