// Count nodes and relationships

MATCH (n)-[r]-(m) 
RETURN COUNT(DISTINCT n) AS nodeCount
      ,COUNT(DISTINCT r) AS relationshipCount