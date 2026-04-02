// Critical path lengths (max build level) per abstraction level after topological sort.
// The maxDistanceFromSource property is set by the Topological Sort algorithm.
// Level 0 = no dependencies (can be built first). Higher level = more transitive dependents above it.
// The maximum level equals the minimum number of sequential build steps even with full parallelism.
// Needs graph-data-science plugin version >= 2.5.0

CALL {
    MATCH (n:Artifact) WHERE n.maxDistanceFromSource IS NOT NULL
    RETURN 'Java Artifact'   AS abstractionLevel
          ,max(n.maxDistanceFromSource) AS maxBuildLevel
          ,count(n)                     AS nodeCount
    UNION ALL
    MATCH (n:Package) WHERE n.maxDistanceFromSource IS NOT NULL
    RETURN 'Java Package'    AS abstractionLevel
          ,max(n.maxDistanceFromSource) AS maxBuildLevel
          ,count(n)                     AS nodeCount
    UNION ALL
    MATCH (n:Module) WHERE n.maxDistanceFromSource IS NOT NULL
    RETURN 'TypeScript Module' AS abstractionLevel
          ,max(n.maxDistanceFromSource) AS maxBuildLevel
          ,count(n)                     AS nodeCount
}
RETURN abstractionLevel
      ,nodeCount
      ,maxBuildLevel
 ORDER BY abstractionLevel
