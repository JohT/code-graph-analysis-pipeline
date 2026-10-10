// Creates HAS_COMMIT relationships from a Git:Repository to its Git:Log:Commit nodes.
// Requires: Pass 1 (Import_git_log_nodes_csv_data.cypher) completed.
// Variables: git_repository_absolute_directory_name

MATCH (git_repository:Git:Repository {absoluteFileName: $git_repository_absolute_directory_name})
MATCH (git_commit:Git:Log:Commit)-[:CONTAINS_CHANGED]->(:Git:Log:File {repositoryPath: $git_repository_absolute_directory_name})
WITH DISTINCT git_repository, git_commit
MERGE (git_repository)-[:HAS_COMMIT]->(git_commit)
RETURN count(DISTINCT git_commit) AS numberOfCommits
