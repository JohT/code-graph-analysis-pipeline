// List git files that where frequently changed with another file. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

MATCH (firstGitFile:Git&File&!Repository)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git&File&!Repository)
WHERE elementId(firstGitFile) < elementId(secondGitFile)
MATCH (gitRepository:Git&Repository)-[:HAS_FILE]->(firstGitFile)
  WITH gitRepository.name + '/' + coalesce(firstGitFile.relativePath, firstGitFile.fileName) AS filePath
      ,sum(gitChange.updateCommitCount)                     AS commitCount
      ,sum(firstGitFile.updateCommitCount)                  AS fileUpdateCount
      ,max(gitChange.updateCommitLift)                      AS maxLift
      ,avg(gitChange.updateCommitLift)                      AS avgLift
  WITH *
      // Out of all the times the file was touched, how often did it co-occur with other files?
      ,CASE WHEN fileUpdateCount > 0 THEN toFloat(commitCount) / fileUpdateCount ELSE 0.0 END AS coChangeRate
RETURN filePath, commitCount, coChangeRate, maxLift, avgLift
ORDER BY commitCount DESC