// Community Detection: Hierarchical Density-Based Spatial Clustering (HDBSCAN) - Statistics

CALL gds.hdbscan.stats(
 $dependencies_projection + '-cleaned', {
    nodeProperty: $dependencies_projection_node_embeddings_property,
    samples: 3
})
 YIELD nodeCount, numberOfClusters, numberOfNoisePoints, preProcessingMillis, computeMillis, postProcessingMillis
RETURN nodeCount, numberOfClusters, numberOfNoisePoints, preProcessingMillis, computeMillis, postProcessingMillis