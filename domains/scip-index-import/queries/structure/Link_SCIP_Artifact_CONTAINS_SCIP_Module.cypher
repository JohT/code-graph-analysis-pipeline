// Link SemanticCodeIndexArtifact nodes to their contained SemanticCodeIndexModule nodes via CONTAINS. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher" and "Create_SCIP_Artifact_Nodes.cypher".

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(t:SemanticCodeIndexInternalType)
MATCH (a:SemanticCodeIndexArtifact {fqn: t.module + ' ' + t.version})
MERGE (a)-[:CONTAINS]->(m)
RETURN count(*) AS writtenRelationships
