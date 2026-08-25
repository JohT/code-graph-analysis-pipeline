// Set "projectName" property on SemanticCodeIndexModule nodes by finding their containing artifact and using its projectName.
// Modules are linked to artifacts via incoming CONTAINS relationships from artifacts.

MATCH (a:SCIP:SemanticCodeIndexArtifact)-[:CONTAINS]->(m:SCIP:SemanticCodeIndexModule)
WHERE a.projectName IS NOT NULL
SET m.projectName = a.projectName
RETURN count(*) AS updatedNodes
