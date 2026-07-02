// Link SCIPArtifact nodes to their contained SCIPModule nodes via CONTAINS. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher" and "Create_SCIP_Artifact_Nodes.cypher".

MATCH (m:SCIPModule)-[:CONTAINS]->(t:SCIPInternalType)
MATCH (a:SCIPArtifact {fqn: t.module + ' ' + t.version})
MERGE (a)-[:CONTAINS]->(m)
RETURN count(*) AS writtenRelationships
