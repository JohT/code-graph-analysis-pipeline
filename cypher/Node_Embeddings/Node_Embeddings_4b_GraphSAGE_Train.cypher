// Node Embeddings 4c using GraphSAGE (Graph Neural Networks): Train. Requires: "Node_Embeddings_0b_Prepare_Degree.cypher".

CALL gds.beta.graphSage.train(
 $dependencies_projection + '-cleaned', {
      modelName: $dependencies_projection + '-graphSAGE'
     ,featureProperties: ['degreeForNodeEmbeddings']
     ,embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
     ,batchSize: 64
     ,activationFunction: 'relu'
     ,sampleSizes: [25, 20, 20, 10]
     //,aggregator: 'pool'
     //,epochs: 10
     //,penaltyL2: 0.0000001
     //,tolerance: 0.0001
     //,learningRate: 0.1
     //,searchDepth: 5
     ,randomSeed: 47
  }
)
YIELD modelInfo AS info, trainMillis
RETURN
  info.modelName           AS modelName,
  info.metrics.didConverge AS didConverge,
  info.metrics.ranEpochs   AS ranEpochs,
  info.metrics.epochLosses AS epochLosses,
  trainMillis              AS trainingTimeMilliseconds