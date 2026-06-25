// Set isExternal property on SemanticCodeIndexArtifact nodes. True if artifact contains only external types, false if contains internal types. Requires "Create_SCIP_Artifact_Nodes.cypher".

MATCH (a:SCIP:SemanticCodeIndexArtifact)
OPTIONAL MATCH (a)-[:CONTAINS]->(internalType:SCIP:InternalType)
 WITH a, count(internalType) AS internalTypeCount
  SET a.isExternal = (internalTypeCount = 0)
RETURN count(*) AS writtenNodes
