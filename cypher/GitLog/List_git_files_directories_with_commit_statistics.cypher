// List git file directories and their statistics

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
  WITH *, split(git_file.relativePath, '/') AS pathElements
  WITH *, pathElements[-1]                  AS fileName
 MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
 MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-[]->(git_file)
  WITH pathElements
      ,fileCreatedAtTimestamp
      ,fileLastModificationAtTimestamp
      ,fileName
      ,git_file.relativePath             AS fileRelativePath
      ,max(git_repository.name)          AS repository
      ,max(git_commit.sha)               AS maxCommitSha
      ,COUNT(DISTINCT git_commit.sha)    AS commitCount
      ,COUNT(DISTINCT git_commit.author) AS authorCount
      ,date(max(git_commit.date))        AS lastCommitDate
UNWIND pathElements AS pathElement
  WITH *
      ,coalesce(nullif(split(fileRelativePath, '/' + pathElement)[0], fileRelativePath), '')  AS parent
  WITH *
      ,coalesce(nullif(parent,'') + '/', '') + pathElement AS directory
 WHERE pathElement <> fileName
  WITH repository                                 AS gitRepositoryName
      ,directory                                  AS directoryPath
      ,split(directory, '/')[-1]                  AS directoryName
      ,parent                                     AS directoryParentPath
      ,split(parent, '/')[-1]                     AS directoryParentName
      ,size(split(directory, '/'))                AS directoryPathLength
      ,count(DISTINCT fileRelativePath)           AS fileCount
      ,max(date(fileCreatedAtTimestamp) )         AS lastCreationDate
      ,max(date(fileLastModificationAtTimestamp)) AS lastModificationDate
      ,sum(commitCount)                           AS commitCount
      ,sum(authorCount)                           AS authorCount
      ,max(maxCommitSha)                          AS maxCommitSha
      ,max(lastCommitDate)                        AS lastCommitDate
      ,duration.inDays(max(lastCommitDate), date()).days                      AS daysSinceLastCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLastCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLastModification
// The final results are grouped by the statistic values like file count,...
RETURN gitRepositoryName
      ,fileCount
      ,lastCreationDate
      ,lastModificationDate
      ,commitCount
      ,authorCount
      ,maxCommitSha
      ,lastCommitDate
      ,daysSinceLastCommit
      ,daysSinceLastCreation
      ,daysSinceLastModification
      ,collect(directoryPath)[-1]                        AS directoryPath
      ,apoc.text.join(collect(directoryName), '/')       AS directoryName
      ,collect(directoryParentPath)[0]                   AS directoryParentPath
      ,collect(directoryParentName)[0]                   AS directoryParentName
      ,max(directoryPathLength)                          AS directoryPathLength
      ,count(DISTINCT directoryPath)                     AS combinedDirectoriesCount