// Node Embeddings 1d using Fast Random Projection: Stream for Hyper-Parameter tuning. Requires "Add_file_name_and_extension.cypher".

CALL gds.fastRP.stream(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,randomSeed: toInteger($dependencies_projection_embedding_random_seed)
     ,normalizationStrength: toFloat($dependencies_projection_fast_random_projection_normalization_strength)
     ,iterationWeights: [0.0, 0.0, 1.0, toFloat($dependencies_projection_fast_random_projection_forth_iteration_weight)]
     ,relationshipWeightProperty: $dependencies_projection_weight_property
  }
)
YIELD nodeId, embedding
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,embedding
 RETURN DISTINCT 
        coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
       ,codeUnit.name                               AS shortCodeUnitName
       ,elementId(codeUnit)                         AS nodeElementId
       ,coalesce(codeUnit.projectName, '')          AS projectName
       ,coalesce(codeUnit.communityLeidenIdTuned, codeUnit.communityLeidenId, 0) AS communityId
       ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
       ,embedding