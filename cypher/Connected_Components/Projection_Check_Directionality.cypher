// Check if the given projection is DIRECTED. Used to validate before Strongly Connected Components (SCC) calculation.
// Returns graphName and direction; empty if projection doesn't exist or is not DIRECTED.
// Parameters: $dependencies_projection (projection name, e.g., "package-anomaly-detection-directed")

CALL gds.graph.list($dependencies_projection)
YIELD graphName, schemaWithOrientation
WITH graphName,
     schemaWithOrientation.relationships['DEPENDS_ON'].direction AS direction
WHERE direction = 'DIRECTED'
RETURN graphName AS projection_name, direction
