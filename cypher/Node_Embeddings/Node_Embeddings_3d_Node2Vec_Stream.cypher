// Node Embeddings 3c using Node2Vec: Stream

CALL gds.node2vec.stream(
 $dependencies_projection + '-cleaned', {
     ,embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
     ,iterations: 3
     ,randomSeed: 30
     ,relationshipWeightProperty: $dependencies_projection_weight_property
  }
)
YIELD nodeId, embedding
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,embedding
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
   WITH *, replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
   WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
 RETURN DISTINCT 
        coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
       ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', '')) AS shortCodeUnitName
       ,coalesce(artifactName, projectName) AS projectName
     ,coalesce(codeUnit.communityLeidenId, 0) AS communityId
     ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
     ,embedding