// Link SemanticCodeIndexProject nodes to their contained SemanticCodeIndexArtifact nodes via CONTAINS relationship.
// Traverses SemanticCodeIndexInternalType and SemanticCodeIndexFunction BELONGS_TO links to find which artifacts belong to each project.
// Requires "Link_SCIP_Artifact_CONTAINS_SCIP_InternalSymbol.cypher", "Link_SCIP_Artifact_CONTAINS_SCIP_Function.cypher", "Import_SCIP_Type_Internal_Nodes.cypher" and "Import_SCIP_Function_Nodes.cypher".

MATCH (p:SCIP:SemanticCodeIndexProject)<-[:BELONGS_TO]-(t:SCIP:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(a:SCIP:SemanticCodeIndexArtifact)
WITH DISTINCT p, a
MERGE (p)-[:CONTAINS]->(a)
RETURN count(*) AS writtenRelationships
