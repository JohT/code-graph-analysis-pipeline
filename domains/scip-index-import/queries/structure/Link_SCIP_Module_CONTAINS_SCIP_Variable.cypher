// Link SemanticCodeIndexModule nodes to their contained SemanticCodeIndexVariable nodes via CONTAINS. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher" and "Import_SCIP_Variable_Nodes.cypher".

MATCH (v:SCIP:SemanticCodeIndexVariable)
 WITH v
     ,CASE
        WHEN v.file CONTAINS '/'
        THEN left(v.file, size(v.file) - size(split(v.file, '/')[-1]) - 1)
        ELSE null
      END AS directoryPath
MATCH (m:SCIP:SemanticCodeIndexModule {fqn: directoryPath})
MERGE (m)-[:CONTAINS]->(v)
RETURN count(*) AS writtenRelationships
