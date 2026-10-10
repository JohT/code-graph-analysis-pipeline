// Count all Git:Log:Commit nodes in the database. Used to verify Pass 1 import completeness.

MATCH (c:Git:Log:Commit)
RETURN count(c) AS commitCount
