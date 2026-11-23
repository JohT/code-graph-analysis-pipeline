// Check if the gds.scc.write procedure is available in Neo4j Graph Data Science library.

SHOW PROCEDURE YIELD name
WHERE name = 'gds.scc.write'
RETURN name
