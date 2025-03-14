// List git files with commit statistics

 MATCH (git_file:File&Git&!Repository)
 WHERE git_file.deletedAt IS NULL // filter out deleted files
 ORDER BY git_file.relativePath
  WITH percentileDisc(git_file.createdAtEpoch, 0.5)          AS medianCreatedAtEpoch
      ,percentileDisc(git_file.lastModificationAtEpoch, 0.5) AS medianLastModificationAtEpoch
      ,collect(git_file)                                     AS git_files
UNWIND git_files AS git_file
  WITH *
      ,datetime.fromepochMillis(coalesce(git_file.createdAtEpoch, medianCreatedAtEpoch))                   AS fileCreatedAtTimestamp
      ,datetime.fromepochMillis(coalesce(git_file.lastModificationAtEpoch, medianLastModificationAtEpoch)) AS fileLastModificationAtTimestamp
 MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
 MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-[]->(git_file)
  WITH *,  split(git_commit.author, ' <')[0]             AS author
  WITH git_repository.name + '/' + git_file.relativePath AS filePath
      ,author
      ,split(git_commit.author, ' <')[0]                 AS commitCountAuthor
      ,count(DISTINCT git_commit.sha)                    AS commitCount
      ,date(max(git_commit.date))                        AS lastCommitDate
      ,max(date(fileCreatedAtTimestamp))                 AS lastCreationDate
      ,max(date(fileLastModificationAtTimestamp))        AS lastModificationDate
      ,duration.inDays(date(max(git_commit.date)), date()).days               AS daysSinceLastCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLastCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLastModification
      ,max(git_commit.sha)                               AS maxCommitSha
ORDER BY filePath ASCENDING, commitCount DESCENDING
RETURN filePath
      ,collect(DISTINCT author)[0]    AS mainAuthor
      ,count(DISTINCT author)         AS authorCount
      ,sum(commitCount)               AS commitCount
      ,max(lastCommitDate)            AS lastCommitDate
      ,max()
      ,min(daysSinceLastCommit)       AS daysSinceLastCommit
      ,min(daysSinceLastCreation)     AS daysSinceLastCreation
      ,min(daysSinceLastModification) AS daysSinceLastModification
      ,max(maxCommitSha)              AS maxCommitSha
