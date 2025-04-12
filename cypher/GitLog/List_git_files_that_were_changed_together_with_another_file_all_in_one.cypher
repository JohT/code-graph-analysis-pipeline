// List git files that where changed together frequently

MATCH (global_git_commit:Git:Commit)
 WITH count(global_git_commit) AS globalCommitCount
MATCH (git_commit:Git:Commit)-[:CONTAINS_CHANGE]->(git_change:Git:Change)-[:UPDATES]->(git_file:Git:File)
MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
WHERE git_file.deletedAt IS NULL
 WITH *, git_repository.name + '/' + git_file.relativePath AS filePath
 WITH globalCommitCount
     ,git_commit.sha             AS commitHash
     ,collect(DISTINCT filePath) AS filesInCommit
WHERE size(filesInCommit) >= 2
  AND size(filesInCommit) <= 50
 WITH globalCommitCount
     ,commitHash
     ,apoc.coll.combinations(filesInCommit, 2, 2) AS fileCombinations
UNWIND fileCombinations AS fileCombination
UNWIND fileCombination  AS filePath
  WITH globalCommitCount
      ,filePath
      ,count(DISTINCT commitHash)      AS commitCount
WHERE commitCount > globalCommitCount * 0.001 // Filter out combinations that are too rare
RETURN filePath
      ,commitCount
ORDER BY commitCount DESC