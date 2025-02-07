// List git file directories and the number of files they contain

 MATCH (git_file:File&Git&!Repository)
OPTIONAL MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-[]->(git_file)
OPTIONAL MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
ORDER BY git_commit.date DESC
  WITH *
      ,git_file.relativePath                                 AS gitFileName
      ,reverse(split(reverse(git_file.relativePath),'/')[0]) AS gitFileNameWithoutPath
  WITH *
      ,rtrim(split(gitFileName, gitFileNameWithoutPath)[0], '/') AS gitDirectoryPath
  WITH git_repository.name                                       AS gitRepositoryName
      ,gitDirectoryPath
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-2],''), 'root') AS directoryParentName
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-1],''), 'root') AS directoryName
      ,size(split(gitDirectoryPath, '/')) AS pathLength
      ,count(DISTINCT gitFileName)        AS fileCount
      ,count(distinct git_commit.sha)     AS commitCount
      ,count(distinct git_commit.author)  AS authorCount
      ,date(max(git_commit.date))         AS latestCommitDate
      ,max(git_commit.epoch)              AS latestCommitEpoch
      ,duration.inDays(date(max(git_commit.date)), date()).days AS daysSinceLatestCommit
// Debugging
//      ,collect(distinct git_commit.sha)[0..9]    AS gitCommitExamples
//      ,collect(distinct git_commit.author)[0..9] AS gitCommitAuthorExamples
//      ,collect(git_file)[0..4]         AS gitFileExamples
//      ,collect(gitFileName)            AS gitFileNameExamples
//      ,collect(gitFileNameWithoutPath) AS gitFileNameWithoutPathExamples
 WHERE fileCount > 1 // Filter out single files and directories with only one file
RETURN gitRepositoryName
      ,gitDirectoryPath
      ,directoryParentName
      ,directoryName
      ,pathLength
      ,fileCount
      ,commitCount
      ,authorCount
      ,latestCommitDate
      ,latestCommitEpoch
      ,daysSinceLatestCommit
// Debugging
//       ,gitFileExamples
//       ,gitFileNameExamples
//       ,gitFileNameWithoutPathExamples
 ORDER BY gitDirectoryPath ASC