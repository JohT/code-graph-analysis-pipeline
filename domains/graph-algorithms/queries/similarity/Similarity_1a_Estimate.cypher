// Similarity Estimate Memory

CALL gds.nodeSimilarity.write.estimate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,relationshipTypes: ['DEPENDS_ON']
    ,writeRelationshipType: 'SIMILAR'
    ,writeProperty: 'score'
    ,topK: 3
})
 YIELD requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView