// List git file directories and their statistics. Uses the aggregated git log schema (Git:Log:Author, Git:Log:ChangeSpan, Git:Log:File). Dates are approximated to the first day of the earliest and latest change span month.

 MATCH (git_repository:Git:Repository)-[:HAS_FILE]->(git_file:Git:Log:File)
 WHERE git_file.deletedAt IS NULL // filter out deleted files
 ORDER BY git_file.fileName
  WITH *
      ,git_repository.name + '/' + git_file.fileName AS filePath
  WITH *, split(filePath, '/')                              AS pathElements
  WITH *, pathElements[-1]                                  AS fileName
 MATCH (git_author:Git:Log:Author)-[:AUTHORED]->(git_change_span:Git:Log:ChangeSpan)-[rel:CONTAINS_CHANGED]->(git_file_in_span:Git:Log:File)-[:HAS_NEW_NAME*0..3]->(git_file)
  WITH pathElements
      ,fileName
      ,filePath                                         AS fileRelativePath
      ,git_author.name                                  AS author
      ,sum(rel.commits)                                 AS commits
      ,min(git_change_span.year * 100 + git_change_span.month)   AS minYearMonth
      ,max(git_change_span.year * 100 + git_change_span.month)   AS maxYearMonth
  WITH *
      ,toInteger(minYearMonth / 100)   AS firstChangeYear
      ,minYearMonth % 100              AS firstChangeMonth
      ,toInteger(maxYearMonth / 100)   AS lastChangeYear
      ,maxYearMonth % 100              AS lastChangeMonth
  WITH *
      ,date({year: firstChangeYear, month: firstChangeMonth, day: 1}) AS firstChangeDateApprox
      ,date({year: lastChangeYear,  month: lastChangeMonth,  day: 1}) AS lastChangeDateApprox
  WITH pathElements
      ,fileName
      ,fileRelativePath
      ,author
      ,commits
      ,firstChangeDateApprox
      ,lastChangeDateApprox
UNWIND pathElements AS pathElement
  WITH *
      ,coalesce(nullif(split(fileRelativePath, '/' + pathElement)[0], fileRelativePath), '')  AS parent
  WITH *
      ,coalesce(nullif(parent,'') + '/', '') + pathElement AS directory
 WHERE pathElement <> fileName
  WITH directory                                  AS directoryPath
      ,split(directory, '/')[-1]                  AS directoryName
      ,parent                                     AS directoryParentPath
      ,split(parent, '/')[-1]                     AS directoryParentName
      ,size(split(directory, '/'))                AS directoryPathLength
      ,author
      ,fileRelativePath
      ,collect(DISTINCT fileRelativePath)         AS files
      ,max(firstChangeDateApprox)                 AS firstChangeDateApprox
      ,max(lastChangeDateApprox)                  AS lastChangeDateApprox
      ,sum(commits)                               AS totalCommits
      ,duration.inDays(max(lastChangeDateApprox), date()).days  AS daysSinceLastCommit
// Assure that the authors are ordered by their commit count descending per directory
ORDER BY directoryPath ASCENDING, totalCommits DESCENDING
  WITH directoryPath
      ,directoryName
      ,directoryParentPath
      ,directoryParentName
      ,directoryPathLength
      ,collect(author)[0]                         AS mainAuthor
      ,collect(author)[1]                         AS secondAuthor
      ,collect(author)[2]                         AS thirdAuthor
      ,count(DISTINCT author)                     AS authorCount
      ,size(apoc.coll.toSet(apoc.coll.flatten(collect(files))))   AS fileCount
      ,sum(totalCommits)                                          AS commitCount
      ,max(firstChangeDateApprox)                 AS lastCreationDate
      ,max(lastChangeDateApprox)                  AS lastModificationDate
      ,max(lastChangeDateApprox)                  AS maxCommitDate
      ,min(daysSinceLastCommit)                   AS daysSinceLastCommit
      ,max(fileRelativePath)                      AS maxFileRelativePath
// The final results are grouped by the statistic values like file count,...
RETURN collect(directoryPath)[-1]                  AS directoryPath
      ,apoc.text.join(collect(directoryName), '/') AS directoryName
      ,collect(directoryParentPath)[0]             AS directoryParentPath
      ,collect(directoryParentName)[0]             AS directoryParentName
      ,mainAuthor
      ,secondAuthor
      ,thirdAuthor
      ,authorCount
      ,fileCount
      ,commitCount
      ,toString(lastCreationDate)                 AS lastCreationDate
      ,toString(lastModificationDate)             AS lastModificationDate
      ,toString(maxCommitDate)                    AS lastCommitDate
      ,daysSinceLastCommit
      ,daysSinceLastCommit                        AS daysSinceLastCreation
      ,daysSinceLastCommit                        AS daysSinceLastModification
      ,''                                         AS maxCommitSha
      ,maxFileRelativePath
      ,max(directoryPathLength)                   AS directoryPathLength
      ,count(DISTINCT directoryPath)              AS combinedDirectoriesCount
