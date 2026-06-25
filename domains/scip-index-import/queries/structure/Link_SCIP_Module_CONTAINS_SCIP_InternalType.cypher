// Link SemanticCodeIndexModule nodes to their contained InternalType nodes via CONTAINS. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher" and "Import_SCIP_Type_Internal_Nodes.cypher".

MATCH (t:SCIP:InternalType)
 WITH t
     ,left(t.file, size(t.file) - size(split(t.file, '/')[-1]) - 1) AS directoryPath
MATCH (m:SCIP:SemanticCodeIndexModule {fqn: directoryPath})
MERGE (m)-[:CONTAINS]->(t)
RETURN count(*) AS writtenRelationships
