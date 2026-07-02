// Link SCIPArtifact nodes to their contained SCIPExternalType nodes via CONTAINS. Requires "Create_SCIP_Artifact_Nodes.cypher" and "Import_SCIP_Type_External_Nodes.cypher".

MATCH (t:SCIPExternalType)
MATCH (a:SCIPArtifact {fqn: t.module + ' ' + t.version})
MERGE (a)-[:CONTAINS]->(t)
RETURN count(*) AS writtenRelationships
