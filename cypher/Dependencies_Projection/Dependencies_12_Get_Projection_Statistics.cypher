// Get dependency projection statistics

 CALL gds.graph.list($dependencies_projection + '-cleaned')
YIELD nodeCount, relationshipCount, density, sizeInBytes, degreeDistribution
RETURN nodeCount
      ,relationshipCount
      ,density
      ,sizeInBytes
      ,degreeDistribution.min
      ,degreeDistribution.mean
      ,degreeDistribution.max
      ,degreeDistribution.p50
      ,degreeDistribution.p75
      ,degreeDistribution.p90
      ,degreeDistribution.p95
      ,degreeDistribution.p99
      ,degreeDistribution.p999