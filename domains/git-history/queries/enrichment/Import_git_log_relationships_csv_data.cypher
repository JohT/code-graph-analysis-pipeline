// DEPRECATED: This single-pass query is replaced by two-pass approach for better performance:
//   - Pass 2a: Import_git_log_files_csv_data.cypher (file node creation)
//   - Pass 2b: Import_git_log_relationships_csv_data_pass2b.cypher (relationship creation)
// Kept for backwards compatibility. Reads gitLog.csv (one row per file change). Requires "Import_git_log_nodes_csv_data.cypher". Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    MATCH (git_commit:Git:Log:Commit {hash: row.hash})
    MERGE (git_file:Git:Log:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    MERGE (git_commit)-[contains_changed_rel:CONTAINS_CHANGED]->(git_file)
      SET contains_changed_rel.changeType = row.change_type
    FOREACH (ignored IN CASE WHEN row.change_type = 'R' THEN [1] ELSE [] END |
        MERGE (old_git_file:Git:Log:File {fileName: row.old_filename, repositoryPath: $git_repository_absolute_directory_name})
        MERGE (old_git_file)-[:HAS_NEW_NAME]->(git_file)
    )
    FOREACH (ignored IN CASE WHEN row.change_type = 'D' THEN [1] ELSE [] END |
        SET git_file.deletedAt = git_commit.timestamp
    )
} IN TRANSACTIONS OF 500 ROWS
RETURN count(DISTINCT row.filename) AS numberOfFiles
      ,count(DISTINCT row.hash)     AS numberOfCommits
