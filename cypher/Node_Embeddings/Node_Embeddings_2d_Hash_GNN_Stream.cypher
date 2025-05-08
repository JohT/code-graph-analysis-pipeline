// Node Embeddings 2c using Hash GNN (Graph Neural Networks): Stream. Requires "Add_file_name and_extension.cypher".

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