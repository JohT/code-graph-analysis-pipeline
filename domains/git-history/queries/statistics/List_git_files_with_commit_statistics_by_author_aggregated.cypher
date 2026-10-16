// List git files with commit statistics per author. Uses the aggregated git log schema (Git:Log:Author, Git:Log:ChangeSpan, Git:Log:File). Dates are approximated to the first day of the earliest and latest change span month.

MATCH (git_author:Git:Log:Author)-[:AUTHORED]->(git_change_span:Git:Log:ChangeSpan)-[rel:CONTAINS_CHANGED]->(git_file:Git:Log:File)
 WITH git_file
     ,git_author.name                                                          AS author
     ,sum(rel.commits)                                                         AS commitCount
     ,min(git_change_span.year * 100 + git_change_span.month)                 AS minYearMonth
     ,max(git_change_span.year * 100 + git_change_span.month)                 AS maxYearMonth
 WITH *
     ,toInteger(minYearMonth / 100)   AS firstChangeYear
     ,minYearMonth % 100              AS firstChangeMonth
     ,toInteger(maxYearMonth / 100)   AS lastChangeYear
     ,maxYearMonth % 100              AS lastChangeMonth
 WITH *
     ,date({year: firstChangeYear, month: firstChangeMonth, day: 1}) AS firstChangeDateApprox
     ,date({year: lastChangeYear,  month: lastChangeMonth,  day: 1}) AS lastChangeDateApprox
MATCH (git_repository:Git:Repository)-[:HAS_FILE]->(git_file)
RETURN git_repository.name + '/' + git_file.fileName                    AS filePath
      ,author
      ,toInteger(commitCount)                                           AS commitCount
      ,toString(lastChangeDateApprox)                                   AS lastCommitDate
      ,toString(firstChangeDateApprox)                                  AS lastCreationDate
      ,toString(lastChangeDateApprox)                                   AS lastModificationDate
      ,duration.inDays(lastChangeDateApprox,  date()).days              AS daysSinceLastCommit
      ,duration.inDays(firstChangeDateApprox, date()).days              AS daysSinceLastCreation
      ,duration.inDays(lastChangeDateApprox,  date()).days              AS daysSinceLastModification
      ,''                                                               AS maxCommitSha
 ORDER BY filePath ASCENDING, commitCount DESCENDING