// Similarity Estimate Memory

CALL gds.nodeSimilarity.write.estimate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,writeRelationshipType: 'SIMILAR'
    ,writeProperty: 'score'
    ,topK: 3
})
 YIELD requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView
RETURN requiredMemory, nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView, mapView