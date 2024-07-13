// Community Detection - Local Clustering Coefficient - Mutate

CALL gds.localClusteringCoefficient.mutate(
 $dependencies_projection + '-cleaned', {
    mutateProperty: $dependencies_projection_write_property
})
 YIELD averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis
RETURN averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis