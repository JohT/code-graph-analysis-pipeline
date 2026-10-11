// Create :SCIP:File nodes from unique file paths in SCIP internal type nodes. Language-agnostic. Requires "Import_SCIP_Type_Internal_Nodes.cypher".

MATCH (t:SCIP:SemanticCodeIndexInternalType)
WHERE t.file IS NOT NULL
 WITH DISTINCT t.file AS filePath
     ,last(split(t.file, '/')) AS fileName
  WITH *
      ,coalesce(nullif(last(split(fileName, '.')), fileName), '') AS fileExtension
  WITH *
      ,substring(fileName, 0, size(fileName) - size(fileExtension) - 1) AS name
MERGE (f:SCIP:File {fileName: fileName, relativePath: filePath, name: name})
RETURN count(*) AS writtenNodes
