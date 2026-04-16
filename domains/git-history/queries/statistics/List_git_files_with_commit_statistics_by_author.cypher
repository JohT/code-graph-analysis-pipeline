// List git files with commit statistics

 MATCH (git_file:File&Git&!Repository)
 WHERE git_file.deletedAt IS NULL // filter out deleted files
  WITH percentileDisc(git_file.createdAtEpoch, 0.5)          AS medianCreatedAtEpoch
      ,percentileDisc(git_file.lastModificationAtEpoch, 0.5) AS medianLastModificationAtEpoch
      ,collect(git_file)                                     AS git_files
UNWIND git_files AS git_file
  WITH *
      ,datetime.fromepochMillis(coalesce(git_file.createdAtEpoch, medianCreatedAtEpoch))                                            AS fileCreatedAtTimestamp
      ,datetime.fromepochMillis(coalesce(git_file.lastModificationAtEpoch, git_file.createdAtEpoch, medianLastModificationAtEpoch)) AS fileLastModificationAtTimestamp
 MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
 MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-->(old_files_included:Git&File&!Repository)-[:HAS_NEW_NAME*0..3]->(git_file)
RETURN git_repository.name + '/' + git_file.relativePath AS filePath
      ,split(git_commit.author, ' <')[0]                 AS author
      ,count(DISTINCT git_commit.sha)                    AS commitCount
      ,collect(DISTINCT git_commit.sha)                  AS commitHashes
      ,date(max(git_commit.date))                        AS lastCommitDate
      ,max(date(fileCreatedAtTimestamp))                 AS lastCreationDate
      ,max(date(fileLastModificationAtTimestamp))        AS lastModificationDate
      ,duration.inDays(date(max(git_commit.date)), date()).days               AS daysSinceLastCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLastCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLastModification
      ,max(git_commit.sha)                               AS maxCommitSha
ORDER BY filePath ASCENDING, commitCount DESCENDING