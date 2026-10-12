// List git files that were changed together frequently in aggregated mode. Uses Git:Log:File nodes which have CHANGED_TOGETHER_WITH relationships. Top 5000 by lift to keep output manageable. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_aggregated_git_files.cypher".

// Start with CHANGED_TOGETHER_WITH relationships (pre-computed) instead of expanding from repository
MATCH (firstGitLogFile:Git:Log:File)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitLogFile:Git:Log:File)
WHERE elementId(firstGitLogFile) < elementId(secondGitLogFile)
// Lazy-match repository only for the result set, not for all files
WITH gitChange, firstGitLogFile, secondGitLogFile
MATCH (gitRepository:Git:Repository)-[:HAS_FILE]->(firstGitLogFile)
RETURN gitRepository.name + '/' + firstGitLogFile.fileName  AS firstFile
      ,gitRepository.name + '/' + secondGitLogFile.fileName AS secondFile
      ,gitChange.updateCommitCount                          AS commitCount
ORDER BY gitChange.updateCommitLift DESC, gitChange.updateCommitCount DESC
LIMIT 5000
