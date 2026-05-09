// Calculates and writes the Betweeness centrality score to determine archetypes.

CALL gds.betweenness.write(
 $projection_name + '-directed-cleaned', {
    relationshipWeightProperty: $projection_weight_property
   ,writeProperty: 'centralityBetweenness'
})
 YIELD nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis