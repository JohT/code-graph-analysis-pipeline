// Node Embeddings 1d using Fast Random Projection: Stream for Hyper-Parameter tuning. Requires "Add_file_name and_extension.cypher".

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
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
   WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
   WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
 RETURN DISTINCT 
        coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
       ,codeUnit.name                               AS shortCodeUnitName
       ,elementId(codeUnit)                         AS nodeElementId
       ,coalesce(artifactName, projectName)         AS projectName
       ,coalesce(codeUnit.communityLeidenIdTuned, codeUnit.communityLeidenId, 0) AS communityId
       ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
       ,embedding