// Delete all WCC-related data: WeaklyConnectedComponent nodes, relationships, and properties.
// For manual testing/reset only. Parameterized by node label ($dependencies_projection_node).

// Count nodes to be reset
WITH 0 AS totalBefore
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityWeaklyConnectedComponentId IS NOT NULL
WITH totalBefore, count(codeUnit) AS nodesToReset

// Remove property from code units
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
REMOVE codeUnit.communityWeaklyConnectedComponentId

// Remove edges from code units to components
MATCH (codeUnit)-[rel:IN_WEAKLY_CONNECTED_COMPONENT]->(:WeaklyConnectedComponent)
WHERE $dependencies_projection_node IN labels(codeUnit)
DELETE rel

// Remove edges from SCC to WCC
MATCH (scc:StronglyConnectedComponent {memberType: $dependencies_projection_node})
MATCH (scc)-[rel:IN_WEAKLY_CONNECTED_COMPONENT]->(:WeaklyConnectedComponent)
DELETE rel

// Delete orphaned WeaklyConnectedComponent nodes
MATCH (component:WeaklyConnectedComponent {memberType: $dependencies_projection_node})
WHERE NOT EXISTS { (component)<-[:IN_WEAKLY_CONNECTED_COMPONENT]-() }
DETACH DELETE component

RETURN nodesToReset AS codeUnitsReset
