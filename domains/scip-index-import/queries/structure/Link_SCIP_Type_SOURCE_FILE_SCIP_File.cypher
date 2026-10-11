// Link SemanticCodeIndexInternalType nodes to their source :SCIP:File via SOURCE_FILE. Requires "Create_SCIP_File_Nodes.cypher".

MATCH (t:SCIP:SemanticCodeIndexInternalType)
WHERE t.file IS NOT NULL
MATCH (f:SCIP:File {relativePath: t.file})
MERGE (t)-[:SOURCE_FILE]->(f)
RETURN count(*) AS writtenRelationships
