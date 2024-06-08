// Import git log CSV data with the following schema: (Git:Log:Author)-[:AUTHORED]->(Git:Log:Commit)-[:CONTAINS]->(Git:Log:File)

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    MERGE (git_author:Git:Log:Author {name: row.author, email: row.email})
    MERGE (git_commit:Git:Log:Commit {
        hash:           row.hash, 
        message:        row.message,
        timestamp:      datetime(row.timestamp),
        timestamp_unix: toInteger(row.timestamp_unix)
    })
    MERGE (git_file:Git:Log:File {fileName: row.filename})
    MERGE (git_author)-[:AUTHORED]->(git_commit)
    MERGE (git_commit)-[:CONTAINS]->(git_file)
} IN TRANSACTIONS OF 1000 ROWS
RETURN count(DISTINCT row.author)   AS numberOfAuthors
      ,count(DISTINCT row.filename) AS numberOfFiles
      ,count(DISTINCT row.hash)     AS numberOfCommits