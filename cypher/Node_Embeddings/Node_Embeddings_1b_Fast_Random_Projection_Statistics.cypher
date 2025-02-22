// Node Embeddings 1b using Fast Random Projection: Statistics

CALL gds.fastRP.stats(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,randomSeed: 30
     ,relationshipWeightProperty: $dependencies_projection_weight_property
  }
)
 YIELD nodeCount, preProcessingMillis,	computeMillis
RETURN nodeCount, preProcessingMillis,	computeMillis