// Link SemanticCodeIndexArtifact nodes directly to their contained SemanticCodeIndexInternalType and SemanticCodeIndexFunction nodes via CONTAINS. Enables direct artifact-to-type/function traversal without module joins. Requires "Create_SCIP_Artifact_Nodes.cypher", "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher", "Link_SCIP_Module_CONTAINS_SCIP_Function.cypher", "Add_SemanticCodeIndexInternalSymbol_Label.cypher".

MATCH (a:SemanticCodeIndexArtifact)-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(t:SemanticCodeIndexInternalSymbol)
MERGE (a)-[:CONTAINS]->(t)
RETURN count(*) AS writtenRelationships
