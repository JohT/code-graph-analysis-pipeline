// Check if there is at least one Git:Commit pointing to a Git:Change containing a Git:File

 MATCH (commit:Git:Commit)-[:CONTAINS_CHANGE]->(change:Git:Change)-->(file:Git:File)
RETURN commit.sha AS commitSha
 LIMIT 1