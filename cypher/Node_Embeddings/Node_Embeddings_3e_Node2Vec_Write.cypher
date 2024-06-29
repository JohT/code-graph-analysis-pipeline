// Node Embeddings 3d using Node2Vec: Write

CALL gds.node2vec.write(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,iterations: 3
     ,randomSeed: 30
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,writeProperty: $dependencies_projection_write_property
  }
)
 YIELD nodePropertiesWritten, lossPerIteration, nodeCount, preProcessingMillis, computeMillis, writeMillis
RETURN nodePropertiesWritten, lossPerIteration, nodeCount, preProcessingMillis, computeMillis, writeMillis