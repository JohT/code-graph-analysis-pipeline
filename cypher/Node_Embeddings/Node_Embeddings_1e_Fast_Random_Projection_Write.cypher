// Node Embeddings 1d using Fast Random Projection: Write

CALL gds.fastRP.write(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,writeProperty: $dependencies_projection_write_property
  }
)
 YIELD nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, writeMillis
RETURN nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, writeMillis