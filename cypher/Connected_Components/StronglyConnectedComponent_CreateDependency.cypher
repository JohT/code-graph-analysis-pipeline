// Create edges between strongly connected components. Requires "StronglyConnectedComponent_CreateNode.cypher".

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
    ,sum(codeUnitDependency[$dependencies_projection_weight_property]) AS aggregatedWeightFromSelectedProperty
    ,sum(codeUnitDependency.weight) AS aggregatedWeightFromWeightProperty
    ,any(dependencyWeight IN collect(codeUnitDependency[$dependencies_projection_weight_property]) WHERE dependencyWeight IS NOT NULL) AS selectedPropertyExistsOnMembers
    ,any(dependencyWeight IN collect(codeUnitDependency.weight) WHERE dependencyWeight IS NOT NULL) AS weightPropertyExistsOnMembers

// 4) Create or update component-level dependency edge
MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
SET componentDependency.dependencyCount = dependencyCount

// 5) Conditionally set the selected weight property (only if exists on members)
FOREACH (_ IN CASE WHEN selectedPropertyExistsOnMembers THEN [1] ELSE [] END |
  SET componentDependency[$dependencies_projection_weight_property] = aggregatedWeightFromSelectedProperty
)

// 6) Conditionally set the weight property (only if different from selected property AND exists on members)
FOREACH (_ IN CASE WHEN $dependencies_projection_weight_property <> 'weight' AND weightPropertyExistsOnMembers THEN [1] ELSE [] END |
  SET componentDependency.weight = aggregatedWeightFromWeightProperty
)
