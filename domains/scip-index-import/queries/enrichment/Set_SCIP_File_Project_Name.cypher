// Set "projectName" property on SemanticCodeIndexInternalFile nodes by finding their associated symbols and their artifact and using its projectName.
// Files are linked to symbols via outgoing SOURCE_FILE relationships.

MATCH (artifact:SCIP:SemanticCodeIndexArtifact)-[:CONTAINS]->(s:SCIP:SemanticCodeIndexInternalSymbol)-[:SOURCE_FILE]->(sourceFile:SCIP:SemanticCodeIndexInternalFile)
WHERE artifact.projectName IS NOT NULL
  SET sourceFile.projectName = artifact.projectName
RETURN count(DISTINCT sourceFile) AS updatedNodes
