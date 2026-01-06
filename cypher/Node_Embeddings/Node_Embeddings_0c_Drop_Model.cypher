// Node Embeddings 0b: Prepare: Calculate Degree Property.

CALL gds.model.drop($dependencies_projection + '-graphSAGE', false)
YIELD modelName,
      modelType,
      modelInfo,
      creationTime,
      trainConfig,
      graphSchema,
      loaded,
      stored,
      published
RETURN modelName,
       modelType,
       modelInfo,
       creationTime,
       trainConfig,
       graphSchema,
       loaded,
       stored,
       published