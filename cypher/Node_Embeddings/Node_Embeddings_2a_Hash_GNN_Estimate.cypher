// Node Embeddings 2a using Hash GNN (Graph Neural Networks): Estimate

CALL gds.beta.hashgnn.stream.estimate(
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
 YIELD requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView
RETURN requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView