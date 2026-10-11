// Creates HAS_PARENT relationships between Git Commit nodes and their parent commits. Handles merge commits with multiple space-separated parent hashes.

MATCH (git_commit:Git:Commit)
WHERE git_commit.parent IS NOT NULL
  AND git_commit.parent <> ''
UNWIND split(git_commit.parent, ' ') AS parentHash
MATCH (parent_commit:Git:Commit{hash: parentHash})
MERGE (git_commit)-[:HAS_PARENT]->(parent_commit)
RETURN count(DISTINCT git_commit.hash) AS numberOfCommitsWithParent