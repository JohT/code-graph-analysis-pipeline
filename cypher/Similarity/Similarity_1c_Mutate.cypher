// Similarity Mutate

 CALL gds.nodeSimilarity.mutate(
  $dependencies_projection + '-cleaned', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,relationshipTypes: ['DEPENDS_ON']
     ,topK: 3
     ,mutateRelationshipType: 'SIMILAR'
     ,mutateProperty: 'score'
 })
YIELD  relationshipsWritten
      ,nodesCompared
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,similarityDistribution
RETURN relationshipsWritten
      ,nodesCompared
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,similarityDistribution.min
      ,similarityDistribution.mean
      ,similarityDistribution.max
      ,similarityDistribution.p50
      ,similarityDistribution.p75
      ,similarityDistribution.p90
      ,similarityDistribution.p95
      ,similarityDistribution.p99
      ,similarityDistribution.p999