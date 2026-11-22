// Create nodes for strongly connected components and connect them to their members. Includes complexity-based classification. Parameterized by node label ($dependencies_projection_node). Requires "Cyclic_Dependencies_SCC_Write.cypher". Only processes components with 3+ members.

// 1) Select all code units that belong to a strongly connected component and sort by dependency degree for naming
MATCH (codeUnit)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
WITH codeUnit
    ,COUNT { (codeUnit)-[:DEPENDS_ON]-() } AS totalDegree
ORDER BY totalDegree DESC

// 2) Group code units by component id and calculate metrics
WITH codeUnit.communityStronglyConnectedComponentId AS componentId
    ,collect(codeUnit) AS members
    ,count(codeUnit) AS componentSize
WHERE componentSize >= 3

// 3) Calculate density: edge_count / (node_count * (node_count - 1))
WITH componentId
    ,members
    ,componentSize
    ,REDUCE(edgeCount = 0, m1 IN members |
       edgeCount + SIZE([m2 IN members WHERE m1 <> m2 AND EXISTS((m1)-[:DEPENDS_ON]->(m2))])) AS internalEdgeCount

// 4) Calculate cumulative weight across all internal and external dependencies
WITH componentId
    ,members
    ,componentSize
    ,internalEdgeCount
    ,CASE WHEN componentSize * (componentSize - 1) = 0 THEN 0.0
          ELSE toFloat(internalEdgeCount) / (componentSize * (componentSize - 1))
     END AS density
    ,REDUCE(totalWeight = 0, m IN members |
       totalWeight + REDUCE(depsWeight = 0, dep IN [(m)-[d:DEPENDS_ON]->() | d] | depsWeight + coalesce(dep[$dependencies_projection_weight_property], 0))) AS cumulativeWeight

// 5) Score components for complexity: size + density + weight, normalized to 0-1
WITH componentId
    ,members
    ,componentSize
    ,density
    ,cumulativeWeight
    ,CASE WHEN componentSize > 0 THEN toFloat(componentSize - 1) / 10.0 ELSE 0.0
     END AS sizeScore

// 6) Final complexity classification: combine normalized scores
WITH componentId
    ,members
    ,componentSize
    ,density
    ,cumulativeWeight
    ,ROUND((sizeScore * 0.4) + (density * 0.3) + 
           (CASE WHEN cumulativeWeight > 1000 THEN 1.0
                 WHEN cumulativeWeight > 100 THEN 0.5
                 ELSE 0.1
            END) * 0.3, 2) AS complexityScore

// 7) Classify by complexity score
WITH componentId
    ,members
    ,componentSize
    ,CASE WHEN complexityScore < 0.3 THEN 'Simple'
          WHEN complexityScore < 0.6 THEN 'Intermediate'
          ELSE 'Complex'
     END AS complexityClassification
    ,density
    ,cumulativeWeight
    ,complexityScore

// 8) Create the StronglyConnectedComponent node
MERGE (component:StronglyConnectedComponent {id: componentId, memberType: $dependencies_projection_node})
WITH *
    ,CASE componentSize WHEN = 1 THEN 'Component ' ELSE 'Cycle group ' END AS componentNamePrefix
CALL apoc.create.addLabels(component, [$dependencies_projection_node + 'Members']) YIELD node
SET component.size = componentSize
   ,component.density = ROUND(density, 3)
   ,component.cumulativeWeight = cumulativeWeight
   ,component.complexityScore = complexityScore
   ,component.classification = complexityClassification
   ,component.name = componentNamePrefix + members[0].name

// 9) Connect members to the component
WITH component, members
UNWIND members AS codeUnit
MERGE (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component)
