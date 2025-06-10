// Node Embeddings 1e using Fast Random Projection: Write for tuned hyper-parameters.

CALL gds.fastRP.write(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,randomSeed: toInteger($dependencies_projection_embedding_random_seed)
     ,normalizationStrength: toFloat($dependencies_projection_fast_random_projection_normalization_strength)
     ,iterationWeights: [0.0, 0.0, 1.0, toFloat($dependencies_projection_fast_random_projection_forth_iteration_weight)]
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,writeProperty: $dependencies_projection_write_property
  }
)
 YIELD nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, writeMillis
RETURN nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, writeMillis