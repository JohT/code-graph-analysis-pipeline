// Import git log commit and author nodes (Pass 1). Reads gitLogCommits.csv (one row per unique commit).
// Requires indexes to be created first. See importGit.sh for full three-pass orchestration.
// Run Import_git_log_files_csv_data.cypher (Pass 2a) and Import_git_log_relationships_csv_data_pass2b.cypher (Pass 2b) afterwards.

LOAD CSV WITH HEADERS FROM "file:///gitLogCommits.csv" AS row
CALL { WITH row
    MERGE (git_author:Git:Log:Author {name: row.author, email: row.email})
    MERGE (git_commit:Git:Log:Commit {hash: row.hash})
    ON CREATE SET
        git_commit.sha            = row.hash,
        git_commit.parent         = coalesce(row.parent, ''),
        git_commit.author         = row.author,
        git_commit.date           = date(datetime({epochSeconds: toInteger(row.timestamp_unix)})),
        git_commit.message        = row.message,
        git_commit.timestamp      = datetime({epochSeconds: toInteger(row.timestamp_unix)}),
        git_commit.timestamp_unix = toInteger(row.timestamp_unix)
    MERGE (git_author)-[:AUTHORED]->(git_commit)
} IN TRANSACTIONS OF 500 ROWS
RETURN count(DISTINCT row.author)   AS numberOfAuthors
      ,count(DISTINCT row.hash)     AS numberOfCommits
