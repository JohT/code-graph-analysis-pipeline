// Node Embeddings 3c using Node2Vec: Stream. Requires "Add_file_name and_extension.cypher".

CALL gds.node2vec.stream(
 $dependencies_projection + '-cleaned', {
      embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,randomSeed: toInteger($dependencies_projection_embedding_random_seed)
     ,iterations: toInteger($dependencies_projection_node2vec_iterations)
     ,inOutFactor: toFloat($dependencies_projection_node2vec_in_out_factor)
     ,returnFactor: toFloat($dependencies_projection_node2vec_return_factor)
     ,windowSize: toInteger($dependencies_projection_node2vec_window_size)
     ,walksPerNode: toInteger($dependencies_projection_node2vec_walks_per_node)
     ,walkLength: toInteger($dependencies_projection_node2vec_walk_length)
     ,negativeSamplingRate: toInteger($dependencies_projection_node2vec_negative_sampling_rate)
     ,positiveSamplingFactor: toFloat($dependencies_projection_node2vec_positive_sampling_factor)
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
       ,coalesce(codeUnit.communityLeidenId, 0)     AS communityId
       ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
       ,embedding