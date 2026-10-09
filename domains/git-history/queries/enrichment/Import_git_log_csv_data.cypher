// Import git log CSV data with the following schema: (Git:Log:Author)-[:AUTHORED]->(Git:Log:Commit)-[:CONTAINS_CHANGED]->(Git:Log:File) , (Git:Repository)-[:HAS_COMMIT]->(Git:Log:Commit) , (Git:Repository)-[:HAS_AUTHOR]->(Git:Log:Author) , (Git:Repository)-[:HAS_FILE]->(Git:Log:File). Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///gitLog.csv" AS row
CALL { WITH row
    MATCH (git_repository:Git:Repository{absoluteFileName: $git_repository_absolute_directory_name})
    MERGE (git_author:Git:Log:Author {name: row.author, email: row.email})
    MERGE (git_commit:Git:Log:Commit {hash: row.hash})
    ON CREATE SET
        git_commit.sha            = row.hash,
        git_commit.parent         = coalesce(row.parent, ''),
        git_commit.author         = row.author,
        git_commit.date           = date(datetime(row.timestamp)),
        git_commit.message        = row.message,
        git_commit.timestamp      = datetime(row.timestamp),
        git_commit.timestamp_unix = toInteger(row.timestamp_unix)
    MERGE (git_file:Git:Log:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    MERGE (git_author)-[:AUTHORED]->(git_commit)
    MERGE (git_commit)-[contains_changed_rel:CONTAINS_CHANGED]->(git_file)
      SET contains_changed_rel.changeType = row.change_type
    MERGE (git_repository)-[:HAS_COMMIT]->(git_commit)
    MERGE (git_repository)-[:HAS_AUTHOR]->(git_author)
    MERGE (git_repository)-[:HAS_FILE]->(git_file)
    FOREACH (ignored IN CASE WHEN row.change_type = 'R' THEN [1] ELSE [] END |
        MERGE (old_git_file:Git:Log:File {fileName: row.old_filename, repositoryPath: $git_repository_absolute_directory_name})
        MERGE (old_git_file)-[:HAS_NEW_NAME]->(git_file)
        MERGE (git_repository)-[:HAS_FILE]->(old_git_file)
    )
    FOREACH (ignored IN CASE WHEN row.change_type = 'D' THEN [1] ELSE [] END |
        SET git_file.deletedAt = git_commit.timestamp
    )
} IN TRANSACTIONS OF 1000 ROWS
RETURN count(DISTINCT row.author)   AS numberOfAuthors
      ,count(DISTINCT row.filename) AS numberOfFiles
      ,count(DISTINCT row.hash)     AS numberOfCommits