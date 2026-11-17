// Link SCIP:File nodes to the File nodes they depend on via DEPENDS_ON. 
// Aggregates all symbol-level dependencies where symbols from different files depend on each other.
// Requires "Create_SCIP_File_Nodes.cypher" and "Link_SCIP_Symbol_SOURCE_FILE_SCIP_File.cypher".

MATCH (sourceFile:SCIP:File)<-[:SOURCE_FILE]-(sourceSymbol:SemanticCodeIndexInternalSymbol)
MATCH (sourceSymbol)-[symbolDependency:DEPENDS_ON]->(dependentSymbol:SemanticCodeIndexInternalSymbol)
MATCH (dependentSymbol)-[:SOURCE_FILE]->(dependentFile:SCIP:File)
WHERE sourceFile <> dependentFile
  AND sourceFile.relativePath <> dependentFile.relativePath
  WITH sourceFile
      ,dependentFile
      ,SUM(symbolDependency.referenceCount) AS fileDependencyReferenceCount
      ,REDUCE(interfaces=0, depSymbol IN COLLECT(DISTINCT dependentSymbol) | 
         CASE WHEN depSymbol.isAbstract THEN interfaces + 1 ELSE interfaces END ) AS fileDependencyAbstractReferenceCount
  CALL { WITH sourceFile, dependentFile
             ,fileDependencyReferenceCount, fileDependencyAbstractReferenceCount
        MERGE (sourceFile)-[dependency:DEPENDS_ON]->(dependentFile)
          SET dependency.referenceCount         = fileDependencyReferenceCount
             ,dependency.abstractReferenceCount = fileDependencyAbstractReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN sourceFile.relativePath, dependentFile.relativePath, fileDependencyReferenceCount, fileDependencyAbstractReferenceCount
