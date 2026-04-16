// Delete all Git log data in the Graph

MATCH (n:Git)
CALL { WITH n
DETACH DELETE n
} IN TRANSACTIONS OF 1000 ROWS
RETURN count(n) as numberOfDeletedRows