// Set updateCommitCount on Git:Log:File nodes (number of change spans containing the file) and propagate to code files via RESOLVES_TO. Uses the aggregated git log schema.

MATCH (git_file:Git:Log:File)<-[:CONTAINS_CHANGED]-(:Git:Log:ChangeSpan)
 WITH git_file, count(*) AS updateCommitCount
  SET git_file.updateCommitCount = updateCommitCount
 WITH git_file, updateCommitCount
MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file)
 WITH code_file, sum(git_file.updateCommitCount) AS totalUpdateCommitCount
  SET code_file.updateCommitCount = totalUpdateCommitCount
RETURN count(DISTINCT code_file) AS codeFileUpdates