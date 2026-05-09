// Return the first node with a "topologicalSortMaxDistanceFromSource" if it exists

   MATCH (component:StronglyConnectedComponent)
   WHERE $projection_node_label + 'Members' IN labels(component)
     AND component.topologicalSortMaxDistanceFromSource       IS NOT NULL
  RETURN component.name                                       AS shortCodeUnitName
        ,elementId(component)                                 AS nodeElementId
        ,component.topologicalSortMaxDistanceFromSource       AS topologicalSortMaxDistanceFromSource
   LIMIT 1