// Link SemanticCodeIndexModule nodes to their contained SCIP File nodes via CONTAINS. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher" and "Create_SCIP_File_Nodes.cypher".

MATCH (module:SCIP:SemanticCodeIndexModule)-[:CONTAINS]->(moduleSymbol:SCIP:SemanticCodeIndexInternalSymbol)-[:SOURCE_FILE]->(moduleFile:SCIP:File)
MERGE (module)-[:CONTAINS]->(moduleFile)
RETURN count(*) AS writtenRelationships
