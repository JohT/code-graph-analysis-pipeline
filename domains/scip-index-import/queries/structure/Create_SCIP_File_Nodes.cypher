// Create :SCIP:File nodes from unique file paths in SCIP internal type nodes. Language-agnostic. Requires "Import_SCIP_Type_Internal_Nodes.cypher".

MATCH (t:SCIP:SemanticCodeIndexInternalSymbol)
WHERE t.file IS NOT NULL
 WITH DISTINCT t.file AS filePath
 WITH *
     ,split(filePath, '/')    AS filePathElements
  WITH *
      ,last(filePathElements) AS fileName
  WITH *
      ,coalesce(nullif(last(split(fileName, '.')), fileName), '') AS fileExtension
  WITH *
      ,CASE WHEN fileExtension = '' THEN fileName
            ELSE substring(fileName, 0, size(fileName) - size(fileExtension) - 1)
       END AS name
  WITH *
      ,CASE WHEN size(filePathElements) <= 1 THEN ""
            ELSE left(filePath, size(filePath) - size(last(filePathElements)) - 1)
       END AS directory
MERGE (f:SCIP:File:SemanticCodeIndexInternalFile {fileName: fileName, relativePath: filePath, name: name, fileExtension: fileExtension, directory: directory})
RETURN count(*) AS writtenNodes
