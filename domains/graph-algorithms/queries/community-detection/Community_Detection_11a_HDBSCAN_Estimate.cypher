// Community Detection: Hierarchical Density-Based Spatial Clustering (HDBSCAN) - Estimate

CALL gds.hdbscan.write.estimate(
 $dependencies_projection + '-cleaned', {
    nodeProperty: $dependencies_projection_node_embeddings_property,
    writeProperty: $dependencies_projection_write_property,
    samples: 3
})
 YIELD requiredMemory
      ,nodeCount
      ,relationshipCount
      ,bytesMin
      ,bytesMax
      ,heapPercentageMin
      ,heapPercentageMax
      ,treeView
      ,mapView
RETURN requiredMemory
      ,nodeCount
      ,relationshipCount
      ,bytesMin
      ,bytesMax
      ,heapPercentageMin
      ,heapPercentageMax
      ,treeView
      //,mapView //doesn't work on Windows with git bash jq version jq-1.7-dirty