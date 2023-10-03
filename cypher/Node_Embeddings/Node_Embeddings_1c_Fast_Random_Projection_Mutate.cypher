// Node Embeddings 1c using Fast Random Projection: Mutate

CALL gds.fastRP.mutate(
 $dependencies_projection + '-without-empty', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,mutateProperty: $dependencies_projection_write_property
  }
)
 YIELD nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, mutateMillis
RETURN nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, mutateMillis