// Community Detection K-Core Decomposition write node property communitykCoreDecompositionValue

CALL gds.kcore.write(
 $dependencies_projection + '-without-empty', {
    writeProperty: $dependencies_projection_write_property
})
YIELD degeneracy
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
RETURN degeneracy
      ,preProcessingMillis
      ,computeMillis
      ,writeMillis
      ,postProcessingMillis
      ,nodePropertiesWritten