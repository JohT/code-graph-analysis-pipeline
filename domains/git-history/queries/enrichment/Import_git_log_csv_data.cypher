// Import git log CSV data with the following schema: (Git:Log:Author)-[:AUTHORED]->(Git:Log:Commit)-[:CONTAINS]->(Git:Log:File) , (Git:Repository)-[:HAS_HAS_COMMIT]->(Git:Log:Commit) , (Git:Repository)-[:HAS_HAS_AUTHOR]->(Git:Log:Author) , (Git:Repository)-[:HAS_HAS_FILE]->(Git:Log:File). Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    MATCH (git_repository:Git:Repository{absoluteFileName: $git_repository_absolute_directory_name})
    MERGE (git_author:Git:Log:Author {name: row.author, email: row.email})
    MERGE (git_commit:Git:Log:Commit {
        sha:            row.hash, 
        hash:           row.hash, 
        parent:         coalesce(row.parent, ''), 
        message:        row.message,
        timestamp:      datetime(row.timestamp),
        timestamp_unix: toInteger(row.timestamp_unix)
    })
    MERGE (git_file:Git:Log:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    MERGE (git_author)-[:AUTHORED]->(git_commit)
    MERGE (git_commit)-[:CONTAINS_CHANGED]->(git_file)
    MERGE (git_repository)-[:HAS_COMMIT]->(git_commit)
    MERGE (git_repository)-[:HAS_AUTHOR]->(git_author)
    MERGE (git_repository)-[:HAS_FILE]->(git_file)
} IN TRANSACTIONS OF 1000 ROWS
RETURN count(DISTINCT row.author)   AS numberOfAuthors
      ,count(DISTINCT row.filename) AS numberOfFiles
      ,count(DISTINCT row.hash)     AS numberOfCommits