// Create nodes for strongly connected components and connect them to their members. Requires "AnomalyDetectionFeature-StronglyConnectedComponents-Write.cypher".

// 1) Select all code units that belong to a strongly connected component
//    and sort them by PageRank (used later for naming the component)   MATCH (codeUnit)
   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityStronglyConnectedComponentId IS NOT NULL
   ORDER BY codeUnit.centralityPageRank DESC
// 2) Group code units by strongly connected component id
    WITH codeUnit.communityStronglyConnectedComponentId AS componentId
        ,collect(codeUnit)                              AS members
        ,count(codeUnit)                                AS componentSize
// 3) Create or update the StronglyConnectedComponent node with member type label e.g. ("TypeMembers") 
//    - size: number of code units in the component
//    - name: derived from the highest PageRank member
   MERGE (component:StronglyConnectedComponent {id: componentId})
    WITH *
        ,CASE componentSize WHEN = 1 THEN 'Component ' ELSE 'Cycle around ' END AS componentNamePrefix
    CALL apoc.create.addLabels(component, [$projection_node_label + 'Members']) YIELD node
     SET component.size = componentSize
        ,component.name = componentNamePrefix + members[0].name
// 4) Expand members so we can attach relationships
    WITH component, members
  UNWIND members AS codeUnit
// 5) Connect the code units to the StronglyConnectedComponent they belong to.
   MERGE (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component)