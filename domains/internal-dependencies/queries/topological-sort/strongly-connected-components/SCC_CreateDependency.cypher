// Create edges between strongly connected components. Requires "SCC_CreateNode.cypher".

MATCH (sourceCodeUnit)-[codeUnitDependency:DEPENDS_ON]->(targetCodeUnit)
WHERE $dependencies_projection_node IN labels(sourceCodeUnit)
  AND $dependencies_projection_node IN labels(targetCodeUnit)
MATCH (sourceCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(sourceComponent:StronglyConnectedComponent)
MATCH (targetCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(targetComponent:StronglyConnectedComponent)
WHERE sourceComponent <> targetComponent
WITH sourceComponent, targetComponent
    ,count(*) AS weightCount
    ,sum(codeUnitDependency.weight) AS weight
    ,CASE $dependencies_projection_weight_property
          WHEN '' THEN sum(codeUnitDependency.weight)
          ELSE sum(codeUnitDependency[$dependencies_projection_weight_property])
     END AS weightSelected

MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
SET componentDependency.weightCount = weightCount
   ,componentDependency.weight = weight
   ,componentDependency[$dependencies_projection_weight_property] = weightSelected
