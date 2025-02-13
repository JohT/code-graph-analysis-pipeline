// List git file directories and the number of files they contain

 MATCH (git_file:File&Git&!Repository)
OPTIONAL MATCH (git_commit:Git&Commit)-[:CONTAINS_CHANGE]->(git_change:Git&Change)-[]->(git_file)
  WITH *
      ,git_file.relativePath                                 AS gitFileName
      ,reverse(split(reverse(git_file.relativePath),'/')[0]) AS gitFileNameWithoutPath
      ,(git_file:Directory) AS isDirectory
  WITH *
      ,rtrim(split(gitFileName, gitFileNameWithoutPath)[0], '/') AS gitDirectoryPath
  WITH gitDirectoryPath
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-2],''), 'root') AS directoryParentName
      ,coalesce(nullif(split(gitDirectoryPath, '/')[-1],''), 'root') AS directoryName
      ,size(split(gitDirectoryPath, '/'))                 AS pathLength
      ,count(DISTINCT gitFileName)                        AS fileCount
      ,count(distinct git_commit.sha)                     AS commitCount
      ,count(distinct git_commit.author)                  AS authorCount
// Debugging
//      ,collect(distinct git_commit.sha)[0..9]             AS gitCommitExamples
//      ,collect(distinct git_commit.author)[0..9]          AS gitCommitAuthorExamples
//      ,collect(git_file)[0..4]         AS gitFileExamples
//      ,collect(gitFileName)            AS gitFileNameExamples
//      ,collect(gitFileNameWithoutPath) AS gitFileNameWithoutPathExamples
 WHERE fileCount > 1
RETURN gitDirectoryPath
      ,directoryParentName
      ,directoryName
      ,pathLength
      ,fileCount
      ,commitCount
      ,authorCount
// Debugging
//       ,gitFileExamples
//       ,gitFileNameExamples
//       ,gitFileNameWithoutPathExamples
 ORDER BY gitDirectoryPath ASC