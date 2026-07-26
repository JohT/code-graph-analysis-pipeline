// Propagate topological sort results from SCC components back to their member nodes. Requires "SCC_TopologicalSort_Write.cypher".

MATCH (codeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(component:StronglyConnectedComponent)
WHERE $dependencies_projection_node IN labels(codeUnit)
  AND component.topologicalSortMaxDistanceFromSource IS NOT NULL
  AND component.topologicalSortIndex IS NOT NULL
SET codeUnit.maxDistanceFromSource = component.topologicalSortMaxDistanceFromSource
   ,codeUnit.topologicalSortIndex = component.topologicalSortIndex

RETURN count(codeUnit) AS membersUpdated
      ,count(DISTINCT component) AS componentsProcessed
