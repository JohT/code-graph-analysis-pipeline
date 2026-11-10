// Set isTest and testMarkerInteger on SemanticCodeIndexArtifact nodes based on whether any contained SemanticCodeIndexInternalType is a test. Requires "Link_SCIP_Artifact_CONTAINS_SCIP_InternalSymbol.cypher".

MATCH (a:SemanticCodeIndexArtifact)
OPTIONAL MATCH (a)-[:CONTAINS]->(t:SemanticCodeIndexInternalSymbol)
 WITH a, true IN collect(t.isTest) AS hasTestType
  SET a.isTest            = hasTestType,
      a.testMarkerInteger = CASE WHEN hasTestType THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
