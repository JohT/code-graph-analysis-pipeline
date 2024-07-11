// Community Detection - Local Clustering Coefficient - Write

CALL gds.localClusteringCoefficient.write(
 $dependencies_projection + '-cleaned', {
    writeProperty: $dependencies_projection_write_property
})
 YIELD averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis