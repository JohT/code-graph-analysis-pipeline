// Creates HAS_FILE relationships from a Git:Repository to its Git:Log:File nodes.
// Requires: Pass 2a (Import_git_log_files_csv_data.cypher) completed to ensure file nodes exist.
// Variables: git_repository_absolute_directory_name

MATCH (git_repository:Git:Repository {absoluteFileName: $git_repository_absolute_directory_name})
MATCH (git_file:Git:Log:File {repositoryPath: $git_repository_absolute_directory_name})
MERGE (git_repository)-[:HAS_FILE]->(git_file)
RETURN count(DISTINCT git_file) AS numberOfFiles
