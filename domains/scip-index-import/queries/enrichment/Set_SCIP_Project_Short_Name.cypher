// Extract and set a short, readable name for SemanticCodeIndexProject nodes from their full projectRoot path.
// Extracts just the last path element: /path/to/react-router-7.13.2 → react-router-7.13.2

MATCH (p:SCIP:SemanticCodeIndexProject)
WHERE p.projectRoot IS NOT NULL
SET p.name = CASE 
              WHEN p.projectRoot CONTAINS '/' 
              THEN REVERSE(SPLIT(REVERSE(p.projectRoot), '/')[0])
              ELSE p.projectRoot
            END
RETURN count(*) AS updatedNodes
