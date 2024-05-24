// Check if there is at least one Java Method, its Type and an Artifact it belongs to.

 MATCH (source:Java:Artifact)-[:CONTAINS]->(package:Java:Package)-[:CONTAINS]->(type:Java:Type)
RETURN elementId(source) AS sourceElementId
 LIMIT 1