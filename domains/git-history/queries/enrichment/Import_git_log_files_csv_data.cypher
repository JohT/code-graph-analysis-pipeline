// Import git log file nodes only (Pass 2a). Reads gitLog.csv and creates all unique file nodes.
// This separates file creation from relationship creation to avoid expensive MERGE lookups during relationship creation.
// Requires: Import_git_log_nodes_csv_data.cypher (Pass 1).
// Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    // Create current file node (use MERGE for deduplication)
    MERGE (git_file:Git:Log:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    
    // Handle renames: create old file node if this is a rename operation
    FOREACH (ignored IN CASE WHEN row.change_type = 'R' THEN [1] ELSE [] END |
        MERGE (old_git_file:Git:Log:File {fileName: row.old_filename, repositoryPath: $git_repository_absolute_directory_name})
        MERGE (old_git_file)-[:HAS_NEW_NAME]->(git_file)
    )
} IN TRANSACTIONS OF 100 ROWS

// Simply return "success" - verification happens by querying actual database count
RETURN count(*) AS csvRowsProcessed
