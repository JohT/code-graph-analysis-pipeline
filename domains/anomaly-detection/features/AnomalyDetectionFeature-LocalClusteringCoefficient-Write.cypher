// Calculates and writes the local clustering coefficient for anomaly detection

CALL gds.localClusteringCoefficient.write(
 $projection_name + '-cleaned', {
    writeProperty: 'communityLocalClusteringCoefficient'
})
 YIELD averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN averageClusteringCoefficient, nodeCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis