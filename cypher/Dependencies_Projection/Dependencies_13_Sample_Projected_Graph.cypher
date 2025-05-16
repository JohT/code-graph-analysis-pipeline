// Creates a smaller projection by sampling the original graph using "Common Neighbour Aware Random Walk"

CALL gds.graph.sample.cnarw(
  $dependencies_projection + '-sampled-cleaned',
  $dependencies_projection,
  {
    samplingRatio: toFloat($dependencies_projection_sampling_ratio)
  }
)
YIELD graphName, fromGraphName, nodeCount, relationshipCount, startNodeCount, projectMillis
RETURN graphName, fromGraphName, nodeCount, relationshipCount, startNodeCount, projectMillis