// List how many change spans (author-months) contain one file, how many contain two files, etc. Uses the aggregated git log schema (Git:Log:ChangeSpan, Git:Log:File). Analog of the files-per-commit distribution for the aggregated schema.

MATCH (git_change_span:Git:Log:ChangeSpan)-[:CONTAINS_CHANGED]->(git_file:Git:Log:File)
 WITH git_change_span, count(DISTINCT git_file.fileName) AS filesPerCommit
RETURN filesPerCommit, count(DISTINCT git_change_span) AS commitCount
 ORDER BY filesPerCommit ASC