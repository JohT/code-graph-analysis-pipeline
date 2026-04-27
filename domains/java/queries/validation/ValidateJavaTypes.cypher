// Check if there is at least one Java Type, its Package and an Artifact it belongs to.

 MATCH (source:Java:Artifact)-[:CONTAINS]->(package:Java:Package)-[:CONTAINS]->(type:Java:Type)
RETURN elementId(source) AS sourceElementId
 LIMIT 1