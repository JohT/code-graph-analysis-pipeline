// Link SemanticCodeIndexModule nodes to their contained SemanticCodeIndexFunction nodes via CONTAINS. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher" and "Import_SCIP_Function_Nodes.cypher".

MATCH (f:SCIP:SemanticCodeIndexFunction)
 WITH f
     ,CASE
        WHEN f.file CONTAINS '/'
        THEN left(f.file, size(f.file) - size(split(f.file, '/')[-1]) - 1)
        ELSE null
      END AS directoryPath
MATCH (m:SCIP:SemanticCodeIndexModule {fqn: directoryPath})
MERGE (m)-[:CONTAINS]->(f)
RETURN count(*) AS writtenRelationships
