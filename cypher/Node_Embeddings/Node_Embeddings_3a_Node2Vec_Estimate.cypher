// Node Embeddings 3a using Node2Vec: Estimate

CALL gds.node2vec.write.estimate(
 $dependencies_projection + '-cleaned', {
     ,embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,iterations: 3
     ,randomSeed: 30
     ,relationshipWeightProperty: $dependencies_projection_weight_property
     ,writeProperty: $dependencies_projection_write_property
  }
)
 YIELD requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView