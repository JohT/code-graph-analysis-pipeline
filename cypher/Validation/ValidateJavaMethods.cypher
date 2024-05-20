// Check if there is at least one Java Method, its Type and an Artifact it belongs to.

 MATCH (source:Java:Artifact)-[:CONTAINS]->(type:Java:Type)-[:DECLARES]->(method:Java:Method)
RETURN elementId(source) AS sourceElementId
 LIMIT 1