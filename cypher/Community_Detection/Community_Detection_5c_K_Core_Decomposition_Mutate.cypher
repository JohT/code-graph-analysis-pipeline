// Community Detection K-Core Decomposition Mutate

CALL gds.kcore.mutate(
 $dependencies_projection + '-without-empty', {
    mutateProperty: $dependencies_projection_write_property
})
 YIELD degeneracy, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis
RETURN degeneracy, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis