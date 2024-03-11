// Data verification DEPENDS_ON relationship distinct label constellations

 MATCH (s)-[r:DEPENDS_ON]->(t)
 WHERE s <> t
RETURN count(DISTINCT s) AS sourceNodeCount