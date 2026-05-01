// Node Embeddings 0c: Drop GraphSAGE Model.

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
       //modelInfo, // Note: map structures are not yet supported.
       creationTime,
       //trainConfig, // Note: map structures are not yet supported.
       //graphSchema, // Note: map structures are not yet supported.
       loaded,
       stored,
       published