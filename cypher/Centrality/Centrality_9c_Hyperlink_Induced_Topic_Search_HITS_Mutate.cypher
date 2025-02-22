// Centrality 9c Hyperlink-Induced Topic Search (HITS) Mutate

  CALL gds.hits.mutate(
 $dependencies_projection + '-cleaned', {
     hitsIterations: 20
    ,authProperty: $dependencies_projection_write_property + 'Authority'
    ,hubProperty: $dependencies_projection_write_property + 'Hub'
})
 YIELD nodePropertiesWritten
      ,didConverge
      ,ranIterations
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
RETURN nodePropertiesWritten
      ,didConverge
      ,ranIterations
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis