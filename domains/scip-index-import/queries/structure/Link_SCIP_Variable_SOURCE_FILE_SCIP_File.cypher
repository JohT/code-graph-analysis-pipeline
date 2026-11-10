// Link SemanticCodeIndexVariable nodes to their source :SCIP:File via SOURCE_FILE. Requires "Create_SCIP_File_Nodes.cypher".

MATCH (v:SCIP:SemanticCodeIndexVariable)
WHERE v.file IS NOT NULL
MATCH (sf:SCIP:File {relativePath: v.file})
MERGE (v)-[:SOURCE_FILE]->(sf)
RETURN count(*) AS writtenRelationships
