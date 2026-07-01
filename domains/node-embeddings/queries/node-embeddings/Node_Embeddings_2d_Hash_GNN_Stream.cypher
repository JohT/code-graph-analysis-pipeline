// Node Embeddings 2c using Hash GNN (Graph Neural Networks): Stream. Requires "Add_file_name_and_extension.cypher".

CALL gds.beta.hashgnn.stream(
 $dependencies_projection + '-cleaned', {
      embeddingDensity: toInteger($dependencies_projection_embedding_dimension) * 2
     ,iterations: 3
     ,generateFeatures: {
         dimension: toInteger($dependencies_projection_embedding_dimension) * 4
        ,densityLevel: 3
     }
     ,outputDimension: toInteger($dependencies_projection_embedding_dimension)
     ,neighborInfluence: 0.9
     ,randomSeed: 30
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
       ,coalesce(codeUnit.communityLeidenId, 0)     AS communityId
       ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
       ,embedding