// Reads projection statistics

 CALL gds.graph.list($projection_name + '-cleaned')
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