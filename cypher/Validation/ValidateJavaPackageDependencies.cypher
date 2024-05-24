// Check if there is at least one Java Packagte dependency.

 MATCH (source:Java:Package)-[dependency:DEPENDS_ON]->(target:Java:Package)
RETURN elementId(source) AS sourceElementId
 LIMIT 1