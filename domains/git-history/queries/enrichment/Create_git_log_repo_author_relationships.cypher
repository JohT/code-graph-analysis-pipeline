// Creates HAS_AUTHOR relationships from a Git:Repository to its Git:Log:Author nodes.
// Requires: Pass 1 (Import_git_log_nodes_csv_data.cypher) completed.
// Variables: git_repository_absolute_directory_name

MATCH (git_repository:Git:Repository {absoluteFileName: $git_repository_absolute_directory_name})
MATCH (git_author:Git:Log:Author)-[:AUTHORED]->(:Git:Log:Commit)-[:CONTAINS_CHANGED]->(:Git:Log:File {repositoryPath: $git_repository_absolute_directory_name})
WITH DISTINCT git_repository, git_author
MERGE (git_repository)-[:HAS_AUTHOR]->(git_author)
RETURN count(DISTINCT git_author) AS numberOfAuthors
