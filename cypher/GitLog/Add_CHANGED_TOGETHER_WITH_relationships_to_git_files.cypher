// Connect git files that where changed together frequently with "CHANGED_TOGETHER_WITH"

MATCH (global_git_commit:Git:Commit)
 WITH count(global_git_commit) AS globalCommitCount
MATCH (git_commit:Git:Commit)-[:CONTAINS_CHANGE]->(git_change:Git:Change)-[:UPDATES]->(git_file:Git:File)
MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
WHERE git_file.deletedAt IS NULL
// Order files to assure, that pairs of distinct files are grouped together (fileA, fileB) without (fileB, fileA)
ORDER BY git_commit.sha, git_file.relativePath
 WITH globalCommitCount
     ,git_commit.sha             AS commitHash
     ,collect(DISTINCT git_file) AS filesInCommit
// Limit the file count to min. 2 (changed together) and
// max. 50 (reduce permutations, improve performance, filter out large refactorings that usually affect many files)
WHERE size(filesInCommit) >= 2
  AND size(filesInCommit) <= 50
// Collect distinct pairwise (..., 2, 2) combinations of all files in the list
 WITH globalCommitCount
     ,commitHash
     ,apoc.coll.combinations(filesInCommit, 2, 2) AS fileCombinations
UNWIND fileCombinations AS fileCombination
  WITH globalCommitCount
      ,fileCombination
      ,count(DISTINCT commitHash)      AS commitCount
      ,collect(DISTINCT commitHash)    AS commitHashes
// Filter out file pairs that where changed not very often together 
// In detail: More than 0.1 per mille compared to overall commit count
WHERE commitCount > globalCommitCount * 0.001 
 WITH fileCombination[0] AS firstFile
     ,fileCombination[1] AS secondFile
     ,commitCount
     ,commitHashes
// Create the new relationship "CHANGED_TOGETHER_WITH" and set the property "commitCount" on it
 CALL (firstFile, secondFile, commitCount, commitHashes) {
       MERGE (firstFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile)
         SET pairwiseChange.commitCount  = commitCount
            ,pairwiseChange.commitHashes = commitHashes
       } IN TRANSACTIONS
// Return one row with some statistics about the found pairs and their commit counts
RETURN max(commitCount)                  AS maxCommitCount
      ,avg(commitCount)                  AS avgCommitCount
      ,percentileDisc(commitCount, 0.5)  AS percentile50CommitCount
      ,percentileDisc(commitCount, 0.9)  AS percentile90CommitCount
      ,percentileDisc(commitCount, 0.95) AS percentile95CommitCount
      ,count(*)                          AS pairCount