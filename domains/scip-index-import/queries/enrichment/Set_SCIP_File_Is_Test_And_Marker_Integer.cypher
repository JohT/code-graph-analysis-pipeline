// Set isTest and testMarkerInteger on SemanticCodeIndexInternalFile nodes based on whether any contained SemanticCodeIndexInternalSymbol is a test. Requires "Link_SCIP_File_CONTAINS_SCIP_InternalSymbol.cypher".

MATCH (file:SemanticCodeIndexInternalFile)
OPTIONAL MATCH (file)<-[:SOURCE_FILE]-(t:SemanticCodeIndexInternalSymbol)
 WITH file, true IN collect(t.isTest) AS hasTestType
  SET file.isTest            = hasTestType,
      file.testMarkerInteger = CASE WHEN hasTestType THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
