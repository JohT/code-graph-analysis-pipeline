// Create nodes for weakly connected components and connect them to their members. Requires "AnomalyDetectionFeature-StronglyConnectedComponents-CreateNode.cypher".

// 1) Select all code units that belong to a weakly connected component
//    and sort them by PageRank (used later for naming the component)   MATCH (codeUnit)
   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityWeaklyConnectedComponentId IS NOT NULL
   ORDER BY codeUnit.centralityPageRank DESC
// 2) Group code units by weakly connected component id
    WITH codeUnit.communityWeaklyConnectedComponentId AS componentId
        ,collect(codeUnit)                            AS members
// 3) Create or update the WeaklyConnectedComponent node with member type label e.g. ("TypeMembers") 
//    - size: number of code units in the component
//    - name: derived from the highest PageRank member
   MERGE (component:WeaklyConnectedComponent {id: componentId})
    WITH *
    CALL apoc.create.addLabels(component, [$projection_node_label + 'Members']) YIELD node
     SET component.size = size(members)
        ,component.name = 'Island around ' + members[0].name
// 4) Expand members so we can attach relationships and discover Strongly Connected Components
    WITH component, members
  UNWIND members AS codeUnit
// 5) Connect the code units to the WeaklyConnectedComponent they belong to.
//    Additionally, find the StronglyConnectedComponent each code unit belongs to
//    and connect it to the WeaklyConnectedComponent as well.
//    Layers: code unit -> strongly connected component -> weakly connected component
OPTIONAL MATCH (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(stronglyConnectedComponent:StronglyConnectedComponent)
   MERGE (codeUnit)-[:IN_WEAKLY_CONNECTED_COMPONENT]->(component)
   MERGE (stronglyConnectedComponent)-[:IN_WEAKLY_CONNECTED_COMPONENT]->(component)
// 6) Collect code units per StronglyConnectedComponent within this WeaklyConnectedComponent
//    (this allows us to compute StronglyConnectedComponent sizes)
    WITH component, stronglyConnectedComponent, collect(DISTINCT codeUnit) AS stronglyConnectedComponentMembers
   WHERE stronglyConnectedComponent IS NOT NULL
// 7) Compute the size of each StronglyConnectedComponent within each WeaklyConnectedComponent
    WITH component, size(stronglyConnectedComponentMembers) AS stronglyConnectedComponentSize
// 8) Compute the StronglyConnectedComponent size percentiles per WeaklyConnectedComponent
    WITH component
        ,percentileDisc(stronglyConnectedComponentSize, 0.25) AS stronglyConnectedComponentSizePercentile25
        ,percentileDisc(stronglyConnectedComponentSize, 0.50) AS stronglyConnectedComponentSizePercentile50
        ,percentileDisc(stronglyConnectedComponentSize, 0.75) AS stronglyConnectedComponentSizePercentile75
// 9) Store the computed StronglyConnectedComponent size percentiles on the WeaklyConnectedComponent node
     SET component.stronglyConnectedComponentSizePercentile25 = stronglyConnectedComponentSizePercentile25
        ,component.stronglyConnectedComponentSizePercentile50 = stronglyConnectedComponentSizePercentile50
        ,component.stronglyConnectedComponentSizePercentile75 = stronglyConnectedComponentSizePercentile75
        ,component.stronglyConnectedComponentSizeInterQuartileRange = stronglyConnectedComponentSizePercentile75 - stronglyConnectedComponentSizePercentile25