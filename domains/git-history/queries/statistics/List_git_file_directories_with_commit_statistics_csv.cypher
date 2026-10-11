// List git file directories and their statistics. Uses the CSV-imported git log schema (Git:Log:Commit, Git:Log:File). Requires "Set_git_log_file_dates.cypher".

 MATCH (git_repository:Git:Repository)-[:HAS_FILE]->(git_file:Git:Log:File)
 WHERE git_file.deletedAt IS NULL
 ORDER BY coalesce(git_file.relativePath, git_file.fileName)
  WITH *
      ,datetime.fromepochMillis(coalesce(git_file.createdAtEpoch, 0))                                AS fileCreatedAtTimestamp
      ,datetime.fromepochMillis(coalesce(git_file.lastModificationAtEpoch, git_file.createdAtEpoch, 0)) AS fileLastModificationAtTimestamp
  WITH *, git_repository.name + '/' + coalesce(git_file.relativePath, git_file.fileName) AS filePath
  WITH *, split(filePath, '/')                              AS pathElements
  WITH *, pathElements[-1]                                  AS fileName
 MATCH (git_commit:Git:Log:Commit)-[:CONTAINS_CHANGED]->(file_in_commit:Git:Log:File)-[:HAS_NEW_NAME*0..3]->(git_file)
  WITH pathElements
      ,fileCreatedAtTimestamp
      ,fileLastModificationAtTimestamp
      ,fileName
      ,filePath                                         AS fileRelativePath
      ,git_commit.author                                AS author
      ,max(git_commit.hash)                             AS maxCommitSha
      ,collect(DISTINCT git_commit.hash)                AS commitHashes
      ,date(max(git_commit.date))                       AS lastCommitDate
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
      ,collect(DISTINCT fileRelativePath)         AS files
      ,max(date(fileCreatedAtTimestamp))          AS lastCreationDate
      ,max(date(fileLastModificationAtTimestamp)) AS lastModificationDate
      ,apoc.coll.toSet(apoc.coll.flatten(collect(commitHashes))) AS commitHashes
      ,max(maxCommitSha)                          AS maxCommitSha
      ,max(lastCommitDate)                        AS lastCommitDate
      ,max(fileRelativePath)                      AS maxFileRelativePath
      ,duration.inDays(max(lastCommitDate), date()).days                      AS daysSinceLastCommit
      ,duration.inDays(max(fileCreatedAtTimestamp), datetime()).days          AS daysSinceLastCreation
      ,duration.inDays(max(fileLastModificationAtTimestamp), datetime()).days AS daysSinceLastModification
// Assure that the authors are ordered by their commit count descending per directory
ORDER BY directoryPath ASCENDING, size(commitHashes) DESCENDING
  WITH directoryPath
      ,directoryName
      ,directoryParentPath
      ,directoryParentName
      ,directoryPathLength
      ,collect(author)[0]                         AS mainAuthor
      ,collect(author)[1]                         AS secondAuthor
      ,collect(author)[2]                         AS thirdAuthor
      ,count(DISTINCT author)                     AS authorCount
      ,size(apoc.coll.toSet(apoc.coll.flatten(collect(files))))        AS fileCount
      ,size(apoc.coll.toSet(apoc.coll.flatten(collect(commitHashes)))) AS commitCount
      ,max(lastCreationDate)                      AS lastCreationDate
      ,max(lastModificationDate)                  AS lastModificationDate
      ,max(maxCommitSha)                          AS maxCommitSha
      ,max(lastCommitDate)                        AS lastCommitDate
      ,min(daysSinceLastCommit)                   AS daysSinceLastCommit
      ,min(daysSinceLastCreation)                 AS daysSinceLastCreation
      ,min(daysSinceLastModification)             AS daysSinceLastModification
      ,max(maxFileRelativePath)                   AS maxFileRelativePath
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
      ,lastCreationDate
      ,lastModificationDate
      ,lastCommitDate
      ,daysSinceLastCommit
      ,daysSinceLastCreation
      ,daysSinceLastModification
      ,maxCommitSha
      ,maxFileRelativePath
      ,max(directoryPathLength)                          AS directoryPathLength
      ,count(DISTINCT directoryPath)                     AS combinedDirectoriesCount
