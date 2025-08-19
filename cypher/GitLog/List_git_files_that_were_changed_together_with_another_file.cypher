// List git files that where frequently changed with another file. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

MATCH (firstGitFile:Git&File&!Repository)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git&File&!Repository)
MATCH (gitRepository:Git&Repository)-[:HAS_FILE]->(firstGitFile)
UNWIND gitChange.updateCommitHashes AS commitHash
  WITH gitRepository.name + '/' + firstGitFile.relativePath AS filePath
      ,count(DISTINCT commitHash)                           AS commitCount
      ,sum(firstGitFile.updateCommitCount)                  AS fileUpdateCount
  WITH *
      // Out of all the times the file was touched, how often did it co-occur with other files?
      ,CASE WHEN fileUpdateCount > 0 THEN toFloat(commitCount) / fileUpdateCount ELSE 0.0 END AS coChangeRate
RETURN filePath, commitCount, coChangeRate
ORDER BY commitCount DESC