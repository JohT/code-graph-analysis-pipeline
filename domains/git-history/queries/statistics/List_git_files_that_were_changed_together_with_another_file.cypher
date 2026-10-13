// List git files that where frequently changed with another file. Top 1000 by co-change frequency. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

// Start with relationships and aggregate before matching repository
MATCH (firstGitFile:Git:File)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git:File)
WHERE elementId(firstGitFile) < elementId(secondGitFile)
WITH firstGitFile
    ,sum(gitChange.updateCommitCount)     AS commitCount
    ,sum(firstGitFile.updateCommitCount)  AS fileUpdateCount
    ,max(gitChange.updateCommitLift)      AS maxLift
    ,avg(gitChange.updateCommitLift)      AS avgLift
// Lazy-match repository only after aggregation
MATCH (gitRepository:Git:Repository)-[:HAS_FILE]->(firstGitFile)
WITH gitRepository.name + '/' + coalesce(firstGitFile.relativePath, firstGitFile.fileName) AS filePath
    ,commitCount
    ,fileUpdateCount
    ,maxLift
    ,avgLift
// Out of all the times the file was touched, how often did it co-occur with other files?
,CASE WHEN fileUpdateCount > 0 THEN toFloat(commitCount) / fileUpdateCount ELSE 0.0 END AS coChangeRate
RETURN filePath, commitCount, coChangeRate, maxLift, avgLift
ORDER BY commitCount DESC
LIMIT 1000