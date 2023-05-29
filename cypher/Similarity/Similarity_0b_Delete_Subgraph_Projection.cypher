//Similarity 0b Delete Subgraph Projection

 CALL gds.graph.drop('package-similarity-without-empty', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime