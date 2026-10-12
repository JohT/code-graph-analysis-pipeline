// Import aggregated git log CSV data with the following schema: (Git:Log:Author)-[:AUTHORED]->(Git:Log:ChangeSpan)-[:CONTAINS_CHANGED {commits}]->(Git:Log:File) , (Git:Repository)-[:HAS_CHANGE_SPAN]->(Git:Log:ChangeSpan) , (Git:Repository)-[:HAS_AUTHOR]->(Git:Log:Author) , (Git:Repository)-[:HAS_FILE]->(Git:Log:File). Variables: git_repository_absolute_directory_name

LOAD CSV WITH HEADERS FROM "file:///aggregatedGitLog.csv" AS row
CALL { WITH row
    MATCH (git_repository:Git:Repository {absoluteFileName: $git_repository_absolute_directory_name})
    MERGE (git_author:Git:Log:Author {name: row.author, email: row.email})
    // ChangeSpan is keyed by author + year + month: one node per author per month
    MERGE (git_change_span:Git:Log:ChangeSpan {
        authorName:  row.author,
        authorEmail: row.email,
        year:        toInteger(row.year),
        month:       toInteger(row.month)
    })
    MERGE (git_file:Git:Log:File {fileName: row.filename, repositoryPath: $git_repository_absolute_directory_name})
    MERGE (git_author)-[:AUTHORED]->(git_change_span)
    MERGE (git_change_span)-[rel:CONTAINS_CHANGED]->(git_file)
    // commits is per-file: how many commits this author made to this file in this month
      SET rel.commits = toInteger(row.commits)
    MERGE (git_repository)-[:HAS_CHANGE_SPAN]->(git_change_span)
    MERGE (git_repository)-[:HAS_AUTHOR]->(git_author)
    MERGE (git_repository)-[:HAS_FILE]->(git_file)
} IN TRANSACTIONS OF 1000 ROWS
RETURN count(DISTINCT row.author)   AS numberOfAuthors
      ,count(DISTINCT row.filename) AS numberOfFiles
      ,sum(toInteger(row.commits))  AS numberOfCommits