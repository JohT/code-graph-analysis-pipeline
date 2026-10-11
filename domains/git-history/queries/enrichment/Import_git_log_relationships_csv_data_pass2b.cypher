// Import git log commit-file relationships (Pass 2b). Reads gitLog.csv and creates CONTAINS_CHANGED relationships.
// This assumes file nodes already exist from Pass 2a (Import_git_log_files_csv_data.cypher).
// Uses CREATE (not MERGE) for relationships since gitLog.csv is deduplicated by createGitLogData.sh (bash-level dedup via sort -u).
// Uses MATCH (not MERGE) for commits and files to avoid expensive index lookups + label filtering.
// Requires: Import_git_log_nodes_csv_data.cypher (Pass 1) and Import_git_log_files_csv_data.cypher (Pass 2a).
// Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    // MATCH existing commit node by hash (guaranteed to exist from Pass 1)
    // Use single-label predicate matching index definition (INDEX_COMMIT_HASH FOR (n:Commit))
    // Nodes have composite labels (:Git:Log:Commit) which includes :Commit, so index works
    MATCH (git_commit:Commit {hash: row.hash})
    // MATCH existing file node (guaranteed to exist from Pass 2a MERGE)
    // Use single-label predicate matching index definition (INDEX_FILE_NAME FOR (n:File))
    // Nodes have composite labels (:Git:Log:File) which includes :File, so index works
    MATCH (git_file:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    
    // CREATE relationship (not MERGE): safe since gitLog.csv is deduplicated at bash level
    CREATE (git_commit)-[contains_changed_rel:CONTAINS_CHANGED {changeType: row.change_type}]->(git_file)
    
    // Mark deleted files
    FOREACH (ignored IN CASE WHEN row.change_type = 'D' THEN [1] ELSE [] END |
        SET git_file.deletedAt = git_commit.timestamp
    )
} IN TRANSACTIONS OF 500 ROWS
RETURN count(*) AS relationshipsCreated
      ,count(DISTINCT row.filename) AS uniqueFiles
      ,count(DISTINCT row.hash) AS uniqueCommits
