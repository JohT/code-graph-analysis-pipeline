// Similarity Statistics

CALL gds.nodeSimilarity.stats(
  $dependencies_projection + '-without-empty', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,topK: 3
 })
 YIELD nodesCompared
      ,similarityPairs
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,similarityDistribution
RETURN nodesCompared
      ,similarityPairs
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,similarityDistribution.min
      ,similarityDistribution.mean
      ,similarityDistribution.max
      ,similarityDistribution.p50
      ,similarityDistribution.p75
      ,similarityDistribution.p90
      ,similarityDistribution.p95
      ,similarityDistribution.p99