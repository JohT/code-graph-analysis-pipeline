// Create inter-component dependency edges connecting strongly connected components. Parameterized by node label ($dependencies_projection_node). Requires "Cyclic_Dependencies_SCC_CreateNode.cypher".

// 1) Find all DEPENDS_ON edges between members of different components
MATCH (sourceCodeUnit)-[codeUnitDependency:DEPENDS_ON]->(targetCodeUnit)
WHERE $dependencies_projection_node IN labels(sourceCodeUnit)
  AND $dependencies_projection_node IN labels(targetCodeUnit)
  AND sourceCodeUnit.communityStronglyConnectedComponentId IS NOT NULL
  AND targetCodeUnit.communityStronglyConnectedComponentId IS NOT NULL
  AND sourceCodeUnit.communityStronglyConnectedComponentId <> targetCodeUnit.communityStronglyConnectedComponentId

// 2) Match the SCC nodes
MATCH (sourceCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(sourceComponent:StronglyConnectedComponent)
MATCH (targetCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(targetComponent:StronglyConnectedComponent)
WHERE sourceComponent.memberType = $dependencies_projection_node
  AND targetComponent.memberType = $dependencies_projection_node

// 3) Aggregate weights by component pair
WITH sourceComponent
    ,targetComponent
    ,count(*) AS dependencyCount
    ,sum(codeUnitDependency.weight) AS totalWeight

// 4) Create or update component-level dependency edge
MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
SET componentDependency.dependencyCount = dependencyCount
   ,componentDependency.weight = totalWeight
