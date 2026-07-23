// Return first component with both topologicalSortMaxDistanceFromSource AND topologicalSortIndex if they exist

MATCH (component:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(component)
  AND component.topologicalSortMaxDistanceFromSource IS NOT NULL
  AND component.topologicalSortIndex IS NOT NULL
RETURN component.name AS shortCodeUnitName
      ,elementId(component) AS nodeElementId
      ,component.topologicalSortMaxDistanceFromSource AS topologicalSortMaxDistanceFromSource
      ,component.topologicalSortIndex AS topologicalSortIndex
LIMIT 1
