// Check if there is at least one Java Artifact containing a Java Package with at least one Java Type.

MATCH (source:Java:Artifact)-[:CONTAINS]->(package:Java:Package)-[:CONTAINS]->(type:Java:Type) 
RETURN elementId(source) AS sourceElementId
 LIMIT 1