// Create SemanticCodeIndexModule nodes from unique directory portions of source file paths on SemanticCodeIndexInternalType and SemanticCodeIndexFunction nodes. Requires "Import_SCIP_Type_Internal_Nodes.cypher", "Import_SCIP_Function_Nodes.cypher" and "Add_SemanticCodeIndexInternalSymbol_Label.cypher".

MATCH (t:SCIP:SemanticCodeIndexInternalSymbol)
 WITH DISTINCT CASE 
  WHEN NOT t.file CONTAINS '/' 
  THEN null
  ELSE left(t.file, size(t.file) - size(split(t.file, '/')[-1]) - 1)
END AS directoryPath
WHERE directoryPath IS NOT NULL
MERGE (m:SCIP:SemanticCodeIndexModule {fqn: directoryPath})
  SET m.name = split(directoryPath, '/')[-1]
RETURN count(*) AS writtenNodes
