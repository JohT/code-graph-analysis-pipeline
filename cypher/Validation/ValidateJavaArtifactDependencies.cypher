// Check if there is at least one Java Artifact dependency.

 MATCH (source:Java:Artifact:Archive)-[dependency:DEPENDS_ON]->(target:Java:Artifact:Archive)
RETURN elementId(source) AS sourceElementId
 LIMIT 1