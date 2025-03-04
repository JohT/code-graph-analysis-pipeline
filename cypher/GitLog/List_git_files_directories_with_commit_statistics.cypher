// List git file directories and the number of files they contain

 MATCH (git_file:File&Git&!Repository)
  WITH percentileDisc(git_file.createdAtEpoch, 0.5)          AS medianCreatedAtEpoch
      ,percentileDisc(git_file.lastModificationAtEpoch, 0.5) AS medianLastModificationAtEpoch
      //,min(git_file.createdAtEpoch)                          AS oldestCreatedAtEpoch
      //,min(git_file.lastModificationAtEpoch)                 AS oldestLastModificationAtEpoch
      ,collect(git_file) AS git_files
UNWIND git_files AS git_file
  WITH *
      ,datetime.fromepochMillis(coalesce(git_file.createdAtEpoch, medianCreatedAtEpoch))                   AS createdAtTimestamp
      ,datetime.fromepochMillis(coalesce(git_file.lastModificationAtEpoch, medianLastModificationAtEpoch)) AS lastModificationAtTimestamp
 WHERE git_file.deletedAt IS NULL
  WITH *
      ,git_file.relativePath                                         AS gitFileName
      ,reverse(split(reverse(git_file.relativePath),'/')[0])         AS gitFileNameWithoutPath
  WITH *
      ,rtrim(split(gitFileName, gitFileNameWithoutPath)[0], '/')     AS gitDirectoryPath
  WITH *
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-2],''), 'root') AS directoryParentName
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-1],''), 'root') AS directoryName
      ,size(split(gitDirectoryPath, '/'))                            AS directoryPathLength
OPTIONAL MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
OPTIONAL MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-[]->(git_file) 
  WITH *, COUNT { (git_commit)-[:HAS_PARENT]-(:Commit) } AS parentCommitCount
// WHERE parentCommitCount < 2
ORDER BY git_commit.date DESC
  WITH git_repository.name                AS gitRepositoryName
      ,gitDirectoryPath
      ,directoryParentName
      ,directoryName
      ,directoryPathLength
      ,count(DISTINCT gitFileName)        AS fileCount
      ,count(DISTINCT git_commit.sha)     AS commitCount
      ,count(DISTINCT git_commit.author)  AS authorCount
      ,date(max(git_commit.date))         AS latestCommitDate
      ,max(date(createdAtTimestamp) )           AS latestCreationDate
      ,max(date(lastModificationAtTimestamp))   AS latestModificationDate
      ,duration.inDays(date(max(git_commit.date)), date()).days            AS daysSinceLatestCommit
      ,duration.inDays(max(createdAtTimestamp), datetime()).days           AS daysSinceLatestCreation
      ,duration.inDays(max(lastModificationAtTimestamp), datetime()).days  AS daysSinceLatestModification
// Debugging
//      ,collect(DISTINCT git_commit.sha)[0..9]    AS gitCommitExamples
//      ,collect(DISTINCT git_commit.author)[0..9] AS gitCommitAuthorExamples
//      ,collect(git_file)[0..4]         AS gitFileExamples
//      ,collect(gitFileName)            AS gitFileNameExamples
//      ,collect(gitFileNameWithoutPath) AS gitFileNameWithoutPathExamples
 WHERE fileCount > 1 // Filter out single files and directories with only one file
RETURN gitRepositoryName
      ,gitDirectoryPath
      ,directoryParentName
      ,directoryName
      ,directoryPathLength
      ,fileCount
      ,commitCount
      ,authorCount
      ,latestCommitDate
      ,latestCreationDate
      ,latestModificationDate
      ,daysSinceLatestCommit
      ,daysSinceLatestCreation
      ,daysSinceLatestModification
// Debugging
//       ,gitFileExamples
//       ,gitFileNameExamples
//       ,gitFileNameWithoutPathExamples