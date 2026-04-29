// Community Detection Approximate Maximum k-cut Mutate

CALL gds.maxkcut.mutate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,mutateProperty: $dependencies_projection_write_property
    ,k: toInteger($dependencies_maxkcut)
})
 YIELD cutCost, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis
RETURN cutCost, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, mutateMillis