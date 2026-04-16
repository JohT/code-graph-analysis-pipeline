// Check if there is at least one Git:Commit pointing to a Git:Change containing a Git:File from a Git:Repository

 MATCH (commit:Git:Commit)-[:CONTAINS_CHANGE]->(change:Git:Change)-->(file:Git:File)
 MATCH (repository:Git:Repository)-[:HAS_FILE]->(file)
RETURN commit.sha AS commitSha
 LIMIT 1