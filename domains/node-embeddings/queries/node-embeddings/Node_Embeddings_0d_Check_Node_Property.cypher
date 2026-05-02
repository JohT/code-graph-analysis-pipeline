// Check if a node property has been calculated and written on nodes with the given label. Variables: dependencies_projection_node, dependencies_projection_write_property

MATCH (n)
WHERE $dependencies_projection_node IN LABELS(n)
  AND n[$dependencies_projection_write_property] IS NOT NULL
RETURN count(n) AS nodeCount
