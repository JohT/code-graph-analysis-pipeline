// Set updateCommitCount property on Git File nodes when git commits with Update modifier (detected by the plugin) are present

MATCH (git_file:File&Git)<-[:UPDATES]-(:Git&Change)<-[:CONTAINS_CHANGE]-(git_commit:Git&Commit)
WHERE git_file.deletedAt IS NULL
 WITH git_file, count(DISTINCT git_commit.sha) AS updateCommitCount
  SET git_file.updateCommitCount = updateCommitCount
 WITH git_file, updateCommitCount
MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file)
WITH code_file, sum(git_file.updateCommitCount) AS totalUpdateCommitCount
  SET code_file.updateCommitCount = totalUpdateCommitCount
RETURN count(DISTINCT code_file)                      AS codeFileUpdates
      ,collect(DISTINCT code_file.name)[0..4]         AS codeFileExample