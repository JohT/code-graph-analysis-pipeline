// Delete all SCC-related data: StronglyConnectedComponent nodes, relationships, and properties.
// For manual testing/reset only. Parameterized by node label ($dependencies_projection_node).

// Count nodes to be reset
WITH 0 AS totalBefore
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
WITH totalBefore, count(codeUnit) AS nodesToReset

// Remove property from code units
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
REMOVE codeUnit.communityStronglyConnectedComponentId

// Remove edges from code units to components
MATCH (codeUnit)-[rel:IN_STRONGLY_CONNECTED_COMPONENT]->(:StronglyConnectedComponent)
WHERE $dependencies_projection_node IN labels(codeUnit)
DELETE rel

// Delete orphaned StronglyConnectedComponent nodes
MATCH (component:StronglyConnectedComponent {memberType: $dependencies_projection_node})
WHERE NOT EXISTS { (component)<-[:IN_STRONGLY_CONNECTED_COMPONENT]-() }
DETACH DELETE component

RETURN nodesToReset AS codeUnitsReset
