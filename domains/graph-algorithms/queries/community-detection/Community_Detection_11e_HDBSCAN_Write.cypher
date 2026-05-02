// Community Detection: Hierarchical Density-Based Spatial Clustering (HDBSCAN) -  write node property e.g. communityHdbscanLabel

CALL gds.hdbscan.write(
 $dependencies_projection + '-cleaned', {
    nodeProperty: $dependencies_projection_node_embeddings_property,
    writeProperty: $dependencies_projection_write_property,
    samples: 3
})
// Samples = 3 turned out to be needed for 
YIELD nodeCount
     ,numberOfClusters
     ,numberOfNoisePoints
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
RETURN nodeCount
      ,numberOfClusters
      ,numberOfNoisePoints
      ,preProcessingMillis
      ,computeMillis
      ,writeMillis
      ,postProcessingMillis
      ,nodePropertiesWritten