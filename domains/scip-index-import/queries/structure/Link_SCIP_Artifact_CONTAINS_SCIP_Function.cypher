// Link SemanticCodeIndexArtifact nodes directly to their contained SemanticCodeIndexFunction nodes via CONTAINS. Enables direct artifact-to-function traversal without module joins. Requires "Create_SCIP_Artifact_Nodes.cypher" and "Link_SCIP_Module_CONTAINS_SCIP_Function.cypher".

MATCH (a:SemanticCodeIndexArtifact)-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(f:SemanticCodeIndexFunction)
MERGE (a)-[:CONTAINS]->(f)
RETURN count(*) AS writtenRelationships
