//Path Finding 4 Breadth First Search Path
MATCH (source:Package{fqn:'org.axonframework.commandhandling'})
CALL gds.bfs.stream('package-dependencies', {
  sourceNode: source,
  maxDepth: 1
})
YIELD path
RETURN path