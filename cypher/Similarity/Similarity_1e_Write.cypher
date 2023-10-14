// Similarity Write

CALL gds.nodeSimilarity.write(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,writeRelationshipType: 'SIMILAR'
    ,writeProperty: 'score'
    ,topK: 3
})
YIELD nodesCompared
     ,relationshipsWritten
     ,preProcessingMillis
     ,computeMillis
     ,postProcessingMillis
     ,writeMillis
     ,similarityDistribution
RETURN nodesCompared
      ,relationshipsWritten
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,similarityDistribution.min
      ,similarityDistribution.mean
      ,similarityDistribution.max
      ,similarityDistribution.p50
      ,similarityDistribution.p75
      ,similarityDistribution.p90
      ,similarityDistribution.p95
      ,similarityDistribution.p99