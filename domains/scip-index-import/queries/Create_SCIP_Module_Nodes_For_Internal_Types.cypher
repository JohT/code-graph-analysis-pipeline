// Create SCIPModule nodes from unique directory portions of source file paths on SCIPInternalType nodes. Requires "Import_SCIP_Type_Internal_Nodes.cypher".

MATCH (t:SCIPInternalType)
 WITH DISTINCT left(t.file, size(t.file) - size(split(t.file, '/')[-1]) - 1) AS directoryPath
MERGE (m:SCIP:SCIPModule {fqn: directoryPath})
  SET m.name = split(directoryPath, '/')[-1]
RETURN count(*) AS writtenNodes
