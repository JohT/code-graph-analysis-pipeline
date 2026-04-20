// List how many git commits changed one file, how mandy changed two files, ....

MATCH (git_commit:Git:Commit)-[:CONTAINS_CHANGE]->(git_change:Git:Change)-[]->(git_file:Git:File)
 WITH git_commit, count(DISTINCT git_file.relativePath) AS filesPerCommit
RETURN filesPerCommit, count(DISTINCT git_commit.sha)   AS commitCount
ORDER BY filesPerCommit ASC