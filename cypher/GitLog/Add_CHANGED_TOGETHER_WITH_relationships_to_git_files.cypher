// Connect git files that where changed together frequently with "CHANGED_TOGETHER_WITH"

// Determine global file count, global file count threshold (filter out refactoring commits) and global update commits
MATCH (git_commit_global:Git:Commit)-[:CONTAINS_CHANGE]->(:Git:Change)-[:UPDATES]->(git_file_global:Git:File)
WHERE git_file_global.deletedAt IS NULL
 WITH git_commit_global, count(DISTINCT git_file_global) AS commitFileCount
 WITH percentileDisc(commitFileCount, 0.95) AS globalFileCountThreshold
     ,count(git_commit_global)              AS globalUpdateCommitCount
// Main section
MATCH (git_commit:Git:Commit)-[:CONTAINS_CHANGE]->(git_change:Git:Change)-[:UPDATES]->(git_file:Git:File)
MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
WHERE git_file.deletedAt IS NULL
// Order files to assure, that pairs of distinct files are grouped together (fileA, fileB) without (fileB, fileA)
ORDER BY git_commit.sha, git_file.relativePath
 WITH globalFileCountThreshold
     ,globalUpdateCommitCount
     ,git_commit.sha             AS commitHash
     ,collect(DISTINCT git_file) AS filesInCommit
// Limit the file count to min. 2 (changed together) and
// max. 50 (reduce permutations, improve performance, filter out large refactorings that usually affect many files)
WHERE size(filesInCommit) >= 2
  AND size(filesInCommit) <= globalFileCountThreshold
// Collect distinct pairwise (..., 2, 2) combinations of all files in the list
 WITH globalFileCountThreshold
     ,globalUpdateCommitCount
     ,commitHash
     ,apoc.coll.combinations(filesInCommit, 2, 2) AS fileCombinations
UNWIND fileCombinations AS fileCombination
  WITH globalFileCountThreshold
      ,globalUpdateCommitCount
      ,fileCombination
      ,count(DISTINCT commitHash)      AS updateCommitCount
      ,collect(DISTINCT commitHash)    AS updateCommitHashes
// Deactivated: 
// Filter out file pairs that weren't changed very often together 
WHERE updateCommitCount > 2
 WITH *
     ,fileCombination[0] AS firstFile
     ,fileCombination[1] AS secondFile
 WITH *
     // Get the lowest number of git update commits of both files (file pair) 
     ,CASE WHEN firstFile.updateCommitCount < secondFile.updateCommitCount
           THEN firstFile.updateCommitCount
           ELSE secondFile.updateCommitCount
      END AS minUpdateCommitCount
      // Calculate update commit support by dividing the update commit count by the overall commit count for both files
     ,toFloat(firstFile.updateCommitCount)  / globalUpdateCommitCount AS firstFileUpdateSupport
     ,toFloat(secondFile.updateCommitCount) / globalUpdateCommitCount AS secondFileUpdateSupport
 WITH *
      // Expected likelihood that the first and the second file change together given complete randomness
     ,firstFileUpdateSupport * secondFileUpdateSupport AS expectedCoUpdateSupport
 WITH firstFile
     ,secondFile
     ,updateCommitHashes
     ,updateCommitCount
     // Out of all the times the less frequently changed file was touched, how often did it co-occur with the other file?
     ,toFloat(updateCommitCount) / minUpdateCommitCount    AS updateCommitMinConfidence
     // Compared to all commits in general, how high is the percentage of the commits where both files changed together?
     ,toFloat(updateCommitCount) / globalUpdateCommitCount AS updateCommitSupport
     // Lift
     ,toFloat(updateCommitCount) / (globalUpdateCommitCount * expectedCoUpdateSupport) AS updateCommitLift
     // Jaccard Similarity: Of all commits involving either file, how many involved both?
     ,toFloat(updateCommitCount) / (firstFile.updateCommitCount + secondFile.updateCommitCount - updateCommitCount) AS updateCommitJaccardSimilarity
// Create the new relationship "CHANGED_TOGETHER_WITH" and set the property "updateCommitCount" on it
 CALL (firstFile, secondFile, updateCommitCount, updateCommitHashes, updateCommitMinConfidence, updateCommitSupport, updateCommitLift, updateCommitJaccardSimilarity) {
       MERGE (firstFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile)
         SET pairwiseChange.updateCommitCount             = toInteger(updateCommitCount)
            ,pairwiseChange.updateCommitHashes            = updateCommitHashes
            ,pairwiseChange.updateCommitMinConfidence     = updateCommitMinConfidence
            ,pairwiseChange.updateCommitSupport           = updateCommitSupport
            ,pairwiseChange.updateCommitLift              = updateCommitLift
            ,pairwiseChange.updateCommitJaccardSimilarity = updateCommitJaccardSimilarity
       } IN TRANSACTIONS OF 500 ROWS
// Return one row with some statistics about the found pairs and their commit counts
RETURN count(*)                                            AS pairCount

      ,min(updateCommitCount)                              AS minCommitCount
      ,max(updateCommitCount)                              AS maxCommitCount
      ,avg(updateCommitCount)                              AS avgCommitCount
      ,percentileDisc(updateCommitCount, 0.5)              AS percentile50CommitCount
      ,percentileDisc(updateCommitCount, 0.9)              AS percentile90CommitCount
      ,percentileDisc(updateCommitCount, 0.95)             AS percentile95CommitCount

      ,min(updateCommitMinConfidence)                      AS minMinConfidence
      ,max(updateCommitMinConfidence)                      AS maxMinConfidence
      ,avg(updateCommitMinConfidence)                      AS avgMinConfidence
      ,percentileDisc(updateCommitMinConfidence, 0.5)      AS percentile50MinConfidence
      ,percentileDisc(updateCommitMinConfidence, 0.9)      AS percentile90MinConfidence
      ,percentileDisc(updateCommitMinConfidence, 0.95)     AS percentile95MinConfidence

      ,min(updateCommitLift)                               AS minLift
      ,max(updateCommitLift)                               AS maxLift
      ,avg(updateCommitLift)                               AS avgLift
      ,percentileDisc(updateCommitLift, 0.5)               AS percentile50Lift
      ,percentileDisc(updateCommitLift, 0.9)               AS percentile90Lift
      ,percentileDisc(updateCommitLift, 0.95)              AS percentile95Lift

      ,min(updateCommitJaccardSimilarity)                  AS minJaccardSimilarity
      ,max(updateCommitJaccardSimilarity)                  AS maxJaccardSimilarity
      ,avg(updateCommitJaccardSimilarity)                  AS avgJaccardSimilarity
      ,percentileDisc(updateCommitJaccardSimilarity, 0.5)  AS percentile50JaccardSimilarity
      ,percentileDisc(updateCommitJaccardSimilarity, 0.9)  AS percentile90JaccardSimilarity
      ,percentileDisc(updateCommitJaccardSimilarity, 0.95) AS percentile95JaccardSimilarity