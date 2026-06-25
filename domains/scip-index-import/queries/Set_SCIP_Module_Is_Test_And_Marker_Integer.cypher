// Set isTest and testMarkerInteger on SCIPModule nodes based on whether any contained SCIPInternalType is a test. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher".

MATCH (m:SCIPModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(t:SCIPInternalType)
 WITH m, true IN collect(t.isTest) AS hasTestType
  SET m.isTest            = hasTestType,
      m.testMarkerInteger = CASE WHEN hasTestType THEN 1 ELSE 0 END
RETURN count(*) AS writtenNodes
