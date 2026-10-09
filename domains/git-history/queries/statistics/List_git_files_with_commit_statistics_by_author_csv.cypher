// List git files with commit statistics per author. Uses the CSV-imported git log schema (Git:Log:Commit, Git:Log:File). Requires "Set_git_log_file_dates.cypher".

 MATCH (git_file:Git:Log:File)
 WHERE git_file.deletedAt IS NULL
  WITH percentileDisc(git_file.createdAtEpoch, 0.5)          AS medianCreatedAtEpoch
      ,percentileDisc(git_file.lastModificationAtEpoch, 0.5) AS medianLastModificationAtEpoch
      ,collect(git_file)                                      AS git_files
UNWIND git_files AS git_file
  WITH *
      ,datetime.fromepochMillis(coalesce(git_file.createdAtEpoch, medianCreatedAtEpoch, 0))                                            AS fileCreatedAtTimestamp
      ,datetime.fromepochMillis(coalesce(git_file.lastModificationAtEpoch, git_file.createdAtEpoch, medianLastModificationAtEpoch, 0)) AS fileLastModificationAtTimestamp
 MATCH (git_repository:Git:Repository)-[:HAS_FILE]->(git_file)
 MATCH (git_commit:Git:Log:Commit)-[:CONTAINS_CHANGED]->(file_in_commit:Git:Log:File)-[:HAS_NEW_NAME*0..3]->(git_file)
RETURN git_repository.name + '/' + coalesce(git_file.relativePath, git_file.fileName) AS filePath
      ,git_commit.author                                     AS author
      ,count(DISTINCT git_commit.hash)                       AS commitCount
      ,collect(DISTINCT git_commit.hash)                     AS commitHashes
      ,date(max(git_commit.date))                            AS lastCommitDate
      ,max(date(fileCreatedAtTimestamp))                     AS lastCreationDate
      ,max(date(fileLastModificationAtTimestamp))            AS lastModificationDate
      ,duration.inDays(date(max(git_commit.date)), date()).days               AS daysSinceLastCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLastCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLastModification
      ,max(git_commit.hash)                                  AS maxCommitSha
ORDER BY filePath ASCENDING, commitCount DESCENDING
