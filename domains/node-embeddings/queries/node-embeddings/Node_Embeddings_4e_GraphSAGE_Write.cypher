// Node Embeddings 4e using GraphSAGE: Write embeddings back to graph nodes. Requires "Node_Embeddings_4b_GraphSAGE_Train.cypher".

CALL gds.beta.graphSage.write(
  $dependencies_projection + '-cleaned', {
      modelName:     $dependencies_projection + '-graphSAGE'
     ,writeProperty: $dependencies_projection_write_property
  }
)
 YIELD nodePropertiesWritten
      ,writeMillis
RETURN nodePropertiesWritten
      ,writeMillis
