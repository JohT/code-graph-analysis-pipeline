// Return strongly connected component overview metrics for components with 2+ members.
// All components (including single-member) are created internally to ensure cycle-free graph,
// but overview reports only 2+ member components as analysis focus.
// Parameterized by node label ($dependencies_projection_node). Requires "StronglyConnectedComponent_CreateNode.cypher".

 MATCH (scc:StronglyConnectedComponent)<-[:IN_STRONGLY_CONNECTED_COMPONENT]-(member)
 WHERE scc.memberType = $dependencies_projection_node
   AND scc.size > 1
RETURN scc.id               AS componentId
      ,scc.size             AS memberCount
      ,scc.density          AS density
      ,scc.cumulativeWeight AS cumulativeWeight
      ,scc.complexityScore  AS complexityScore
      ,scc.classification   AS classification
      ,scc.name             AS componentName
      ,collect(DISTINCT member.name)[0..5] AS exampleMembers
ORDER BY scc.complexityScore DESC, scc.size DESC
