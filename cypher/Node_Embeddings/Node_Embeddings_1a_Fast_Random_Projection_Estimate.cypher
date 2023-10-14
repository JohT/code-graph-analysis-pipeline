// Node Embeddings 1a using Fast Random Projection: Estimate

CALL gds.fastRP.stream.estimate(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,relationshipWeightProperty: $dependencies_projection_weight_property
  }
)
 YIELD requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView
RETURN requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView