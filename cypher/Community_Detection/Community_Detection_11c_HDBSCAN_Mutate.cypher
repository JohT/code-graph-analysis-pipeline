// Community Detection: Hierarchical Density-Based Spatial Clustering (HDBSCAN) - Mutate

CALL gds.hdbscan.mutate(
 $dependencies_projection + '-cleaned', {
    nodeProperty: $dependencies_projection_node_embeddings_property,
    mutateProperty: $dependencies_projection_write_property,
    samples: 3
})
 YIELD nodeCount, numberOfClusters, numberOfNoisePoints, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis
RETURN nodeCount, numberOfClusters, numberOfNoisePoints, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis