// Community Detection K-Core Decomposition Statistics

CALL gds.kcore.stats(
 $dependencies_projection + '-without-empty', {
})
 YIELD degeneracy, preProcessingMillis, computeMillis, postProcessingMillis
RETURN degeneracy, preProcessingMillis, computeMillis, postProcessingMillis