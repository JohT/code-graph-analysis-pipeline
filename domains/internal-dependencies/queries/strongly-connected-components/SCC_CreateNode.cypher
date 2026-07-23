// Create nodes for strongly connected components and connect them to their members. Requires "SCC_Write.cypher".

// 1) Select all code units that belong to a strongly connected component
//    and sort by degree (in + out dependencies) for representative naming
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
WITH codeUnit,
     COUNT{ (codeUnit)-[:DEPENDS_ON]-() } AS totalDegree
ORDER BY totalDegree DESC

// 2) Group code units by strongly connected component id
WITH codeUnit.communityStronglyConnectedComponentId AS componentId
    ,collect(codeUnit) AS members
    ,count(codeUnit) AS componentSize

// 3) Create or update the StronglyConnectedComponent node
//    - size: number of code units in the component
//    - name: derived from the highest-degree member
MERGE (component:StronglyConnectedComponent {id: componentId, memberType: $dependencies_projection_node})
WITH *
    ,CASE componentSize WHEN = 1 THEN 'Component ' ELSE 'Cycle around ' END AS componentNamePrefix
CALL apoc.create.addLabels(component, [$dependencies_projection_node + 'Members']) YIELD node
SET component.size = componentSize
   ,component.name = componentNamePrefix + members[0].name

// 4-5) Connect the code units to the StronglyConnectedComponent they belong to
WITH component, members
UNWIND members AS codeUnit
MERGE (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component)
