// Set "projectName" property on SemanticCodeIndexArtifact nodes from their containing project.
// Requires "Link_SCIP_Project_CONTAINS_SCIP_Artifact.cypher" and "Set_SCIP_Project_Short_Name.cypher".

MATCH (p:SCIP:SemanticCodeIndexProject)-[:CONTAINS]->(a:SCIP:SemanticCodeIndexArtifact)
WHERE p.name IS NOT NULL
  AND a.projectName IS NULL
SET a.projectName = p.name
RETURN count(*) AS updatedNodes
