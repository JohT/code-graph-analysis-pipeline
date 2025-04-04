// List git files that where changed together frequently

MATCH (global_git_commit:Git:Commit)
 WITH count(global_git_commit) AS globalCommitCount
MATCH (git_commit:Git:Commit)-[:CONTAINS_CHANGE]->(git_change:Git:Change:Update)-[:UPDATES]->(git_file:Git:File)MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
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
  WITH globalCommitCount
      ,apoc.coll.sort(fileCombination) AS fileCombination
      ,count(DISTINCT commitHash)      AS commitCount
WHERE commitCount > globalCommitCount * 0.001 // Filter out combinations that are too rare
RETURN fileCombination[0] AS firstFile
      ,fileCombination[1] AS secondFile
      ,commitCount
ORDER BY commitCount DESC