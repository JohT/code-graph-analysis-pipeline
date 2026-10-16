// List git files that where changed together frequently. Top 5000 by lift to keep output manageable. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

// Start with CHANGED_TOGETHER_WITH relationships (pre-computed) instead of expanding from repository
MATCH (firstGitFile:Git:File)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git:File)
WHERE elementId(firstGitFile) < elementId(secondGitFile)
// Lazy-match repository only for the result set, not for all files
WITH gitChange, firstGitFile, secondGitFile
MATCH (gitRepository:Git:Repository)-[:HAS_FILE]->(firstGitFile)
RETURN gitRepository.name + '/' + firstGitFile.relativePath  AS firstFile
      ,gitRepository.name + '/' + secondGitFile.relativePath AS secondFile
      ,gitChange.updateCommitCount                           AS commitCount
ORDER BY gitChange.updateCommitLift DESC, gitChange.updateCommitCount DESC
LIMIT 5000
