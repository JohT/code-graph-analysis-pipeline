// List how many git commits changed one file, how many changed two files, .... Uses the CSV-imported git log schema (Git:Log:Commit, Git:Log:File).

MATCH (git_commit:Git:Log:Commit)-[:CONTAINS_CHANGED]->(git_file:Git:Log:File)
 WITH git_commit, count(DISTINCT git_file.fileName) AS filesPerCommit
RETURN filesPerCommit, count(DISTINCT git_commit.hash) AS commitCount
ORDER BY filesPerCommit ASC
