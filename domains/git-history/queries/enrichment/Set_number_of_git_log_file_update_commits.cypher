// Set updateCommitCount property on Git Log File nodes when git log CSV commits are present

MATCH (git_file:Git:Log:File)<-[:CONTAINS_CHANGED]-(git_commit:Git:Log:Commit)
 WITH git_file, count(DISTINCT git_commit.hash) AS updateCommitCount
  SET git_file.updateCommitCount = updateCommitCount
 WITH git_file, updateCommitCount
MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file)
  SET code_file.updateCommitCount = updateCommitCount
RETURN count(DISTINCT code_file)                      AS codeFileUpdates
      ,collect(DISTINCT code_file.name)[0..4]         AS codeFileExample
