// Link SemanticCodeIndexArtifact nodes directly to their contained InternalType nodes via CONTAINS. Enables direct artifact-to-type traversal without module joins. Requires "Create_SCIP_Artifact_Nodes.cypher" and "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher".

MATCH (a:SemanticCodeIndexArtifact)-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(t:InternalType)
MERGE (a)-[:CONTAINS]->(t)
RETURN count(*) AS writtenRelationships
