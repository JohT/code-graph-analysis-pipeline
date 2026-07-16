// Link SemanticCodeIndexArtifact nodes to their contained SemanticCodeIndexExternalType nodes via CONTAINS. External artifacts (containing only external types) are marked later in Set_SCIP_Artifact_Is_External.cypher. Requires "Create_SCIP_Artifact_Nodes.cypher" and "Import_SCIP_Type_External_Nodes.cypher".

MATCH (t:SCIP:SemanticCodeIndexExternalType)
MATCH (a:SemanticCodeIndexArtifact {fqn: t.module + ' ' + t.version})
MERGE (a)-[:CONTAINS]->(t)
RETURN count(*) AS writtenRelationships
