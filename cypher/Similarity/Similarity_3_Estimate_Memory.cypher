// Similarity 3 Estimate Memory

CALL gds.nodeSimilarity.write.estimate('package-similarity', {
  writeRelationshipType: 'SIMILAR',
  writeProperty: 'similarityScore'
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory