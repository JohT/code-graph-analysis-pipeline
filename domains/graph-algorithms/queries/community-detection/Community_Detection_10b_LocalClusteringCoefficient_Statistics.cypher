// Community Detection - Local Clustering Coefficient - Statistics

CALL gds.localClusteringCoefficient.stats(
 $dependencies_projection + '-cleaned', {
})
 YIELD averageClusteringCoefficient, nodeCount, preProcessingMillis, computeMillis, postProcessingMillis
RETURN averageClusteringCoefficient, nodeCount, preProcessingMillis, computeMillis, postProcessingMillis