// Check if there is at least one external Java Type dependency.

 MATCH (source:Java:Package)-[:CONTAINS]->(type:Java:Type)-[:DEPENDS_ON]->(externalType:Java:ExternalType)
RETURN elementId(source) AS sourceElementId
 LIMIT 1