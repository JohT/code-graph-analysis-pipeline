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
      ,COUNT(DISTINCT git_commit.sha)    AS commitCount
      ,COUNT(DISTINCT git_commit.author) AS authorCount
      ,date(max(git_commit.date))        AS lastCommitDate
UNWIND pathElements AS pathElement
  WITH *
      ,coalesce(nullif(split(fileRelativePath, '/' + pathElement)[0], fileRelativePath), '')  AS parent
  WITH *
      ,coalesce(nullif(parent,'') + '/', '') + pathElement AS directory
 WHERE pathElement <> fileName
RETURN repository                                 AS gitRepositoryName
      ,directory                                  AS gitDirectoryPath
      ,parent                                     AS directoryParentPath
      ,split(parent, '/')[-1]                     AS directoryParentPathName
      ,parent                                     AS directoryParentName // TODO was directoryParentPathName
      ,split(directory, '/')[-1]                  AS directoryPathName
      ,directory                                  AS directoryName // TODO was directoryPathName
      ,size(split(directory, '/'))                AS directoryPathLength
      ,count(DISTINCT fileRelativePath)           AS fileCount
      ,max(date(fileCreatedAtTimestamp) )         AS latestCreationDate
      ,max(date(fileLastModificationAtTimestamp)) AS latestModificationDate
      ,sum(commitCount)                           AS commitCount
      ,sum(authorCount)                           AS authorCount
      ,max(lastCommitDate)                        AS latestCommitDate
      ,duration.inDays(max(lastCommitDate), date()).days                      AS daysSinceLatestCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLatestCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLatestModification
      // Debugging
      //,collect(DISTINCT fileRelativePath)[0..4]   AS relativePathExamples
      //,collect(DISTINCT fileName)[0..4]           AS fileNameExamples
