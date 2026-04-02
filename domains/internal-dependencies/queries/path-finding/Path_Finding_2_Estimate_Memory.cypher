//Path Finding 2 Estimate Memory
MATCH (source:Package {fqn: 'org.axonframework.commandhandling'})
CALL gds.dfs.stream.estimate('package-dependencies', {
  sourceNode: source
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory