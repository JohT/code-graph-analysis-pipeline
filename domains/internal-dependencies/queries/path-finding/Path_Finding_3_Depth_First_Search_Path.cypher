//Path Finding 3 Depth First Search Path
MATCH (source:Package{fqn:'org.axonframework.commandhandling'})
CALL gds.dfs.stream('package-dependencies', {
  sourceNode: source
})
YIELD path
RETURN path