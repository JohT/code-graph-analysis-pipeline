// List git files that were frequently changed with another file in aggregated mode. Top 1000 by co-change frequency. Uses Git:Log:File nodes with CHANGED_TOGETHER_WITH relationships. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_aggregated_git_files.cypher".

// Start with relationships and aggregate before matching repository
MATCH (firstGitLogFile:Git:Log:File)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitLogFile:Git:Log:File)
WHERE elementId(firstGitLogFile) < elementId(secondGitLogFile)
WITH firstGitLogFile
    ,sum(gitChange.updateCommitCount)       AS commitCount
    ,sum(firstGitLogFile.updateCommitCount) AS fileUpdateCount
    ,max(gitChange.updateCommitLift)        AS maxLift
    ,avg(gitChange.updateCommitLift)        AS avgLift
// Lazy-match repository only after aggregation
MATCH (gitRepository:Git:Repository)-[:HAS_FILE]->(firstGitLogFile)
WITH gitRepository.name + '/' + firstGitLogFile.fileName AS filePath
    ,commitCount
    ,fileUpdateCount
    ,maxLift
    ,avgLift
// Out of all the times the file was touched, how often did it co-occur with other files?
,CASE WHEN fileUpdateCount > 0 THEN toFloat(commitCount) / fileUpdateCount ELSE 0.0 END AS coChangeRate
RETURN filePath, commitCount, coChangeRate, maxLift, avgLift
ORDER BY commitCount DESC
LIMIT 1000
