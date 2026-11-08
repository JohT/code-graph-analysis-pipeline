// Link SemanticCodeIndexFunction nodes to their source :SCIP:File via SOURCE_FILE. Requires "Create_SCIP_File_Nodes.cypher".

MATCH (f:SCIP:SemanticCodeIndexFunction)
WHERE f.file IS NOT NULL
MATCH (sf:SCIP:File {relativePath: f.file})
MERGE (f)-[:SOURCE_FILE]->(sf)
RETURN count(*) AS writtenRelationships
