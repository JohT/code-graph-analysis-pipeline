// Return strongly connected component members: scc_id, scc_name, member_name, member_node_type.
// Parameterized by node label ($dependencies_projection_node). Requires "StronglyConnectedComponent_CreateNode.cypher".

MATCH (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc:StronglyConnectedComponent)
WHERE scc.memberType = $dependencies_projection_node
  AND scc.size > 1
RETURN scc.id                 AS componentId
      ,scc.name               AS componentName
      ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS memberName
      ,codeUnit.name          AS shortMemberName
      ,head(labels(codeUnit)) AS memberNodeType
ORDER BY scc.id, codeUnit.name
