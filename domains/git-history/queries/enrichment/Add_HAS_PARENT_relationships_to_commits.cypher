// Creates a HAS_PARENT relationship between Git Commit nodes and their parent.

MATCH (git_commit:Git:Commit)
MATCH (parent_commit:Git:Commit{hash: git_commit.parent})
MERGE (git_commit)-[:HAS_PARENT]->(parent_commit)
RETURN count(DISTINCT git_commit.hash)  AS numberOfCommitsWithParent