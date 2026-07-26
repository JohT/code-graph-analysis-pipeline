// Link SemanticCodeIndexProject nodes to their contained SemanticCodeIndexArtifact nodes via CONTAINS relationship.
// Traverses SemanticCodeIndexInternalType BELONGS_TO links to find which artifacts belong to each project.
// Requires "Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher" and "Import_SCIP_Type_Internal_Nodes.cypher".

MATCH (p:SCIP:SemanticCodeIndexProject)<-[:BELONGS_TO]-(t:SCIP:SemanticCodeIndexInternalType)<-[:CONTAINS]-(a:SCIP:SemanticCodeIndexArtifact)
WITH DISTINCT p, a
MERGE (p)-[:CONTAINS]->(a)
RETURN count(*) AS writtenRelationships
