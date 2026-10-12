// Connect aggregated git files that were changed together frequently with "CHANGED_TOGETHER_WITH". Uses Git:Log:ChangeSpan as the unit of co-change (one per author per month). Requires "Set_number_of_aggregated_git_log_file_update_commits.cypher".

// Determine global change span count and file count threshold (filters out large bulk changes)
MATCH (git_change_span_global:Git:Log:ChangeSpan)-[:CONTAINS_CHANGED]->(git_file_global:Git:Log:File)
 WITH git_change_span_global, count(DISTINCT git_file_global) AS spanFileCount
 WITH percentileDisc(spanFileCount, 0.95) AS globalFileCountThreshold
     ,count(git_change_span_global)       AS globalChangeSpanCount
// Main section: find files sharing a change span (same author + month)
MATCH (git_change_span:Git:Log:ChangeSpan)-[:CONTAINS_CHANGED]->(git_file:Git:Log:File)
ORDER BY elementId(git_change_span), git_file.fileName
 WITH globalFileCountThreshold
     ,globalChangeSpanCount
     ,git_change_span
     ,collect(DISTINCT git_file) AS filesInSpan
WHERE size(filesInSpan) >= 2
  AND size(filesInSpan) <= globalFileCountThreshold
 WITH globalFileCountThreshold
     ,globalChangeSpanCount
     ,elementId(git_change_span) AS changeSpanId
     ,filesInSpan
     ,apoc.coll.combinations(filesInSpan, 2, 2) AS fileCombinations
UNWIND fileCombinations AS fileCombination
  WITH globalFileCountThreshold
      ,globalChangeSpanCount
      ,fileCombination
      ,count(DISTINCT changeSpanId) AS updateCommitCount
WHERE updateCommitCount > 2
 WITH *
     ,fileCombination[0] AS firstFile
     ,fileCombination[1] AS secondFile
WHERE firstFile <> secondFile
 WITH *
     // Minimum change span count of the two files (for min-confidence denominator)
     ,CASE WHEN firstFile.updateCommitCount < secondFile.updateCommitCount
           THEN firstFile.updateCommitCount
           ELSE secondFile.updateCommitCount
      END AS minUpdateCommitCount
     // Individual file change span support (fraction of all global change spans)
     ,toFloat(firstFile.updateCommitCount)  / globalChangeSpanCount AS firstFileUpdateSupport
     ,toFloat(secondFile.updateCommitCount) / globalChangeSpanCount AS secondFileUpdateSupport
 WITH *
     // Expected co-occurrence likelihood assuming independence
     ,firstFileUpdateSupport * secondFileUpdateSupport AS expectedCoUpdateSupport
 WITH firstFile
     ,secondFile
     ,updateCommitCount
     // Out of all times the less-frequently-changed file was touched, how often did it co-occur with the other?
     ,toFloat(updateCommitCount) / minUpdateCommitCount    AS updateCommitMinConfidence
     // Fraction of all change spans where both files were changed together
     ,toFloat(updateCommitCount) / globalChangeSpanCount   AS updateCommitSupport
     // Lift: actual co-occurrence vs expected under independence
     ,toFloat(updateCommitCount) / (globalChangeSpanCount * expectedCoUpdateSupport) AS updateCommitLift
     // Jaccard: of all change spans involving either file, how many involved both?
     ,toFloat(updateCommitCount) / (firstFile.updateCommitCount + secondFile.updateCommitCount - updateCommitCount) AS updateCommitJaccardSimilarity
 CALL (firstFile, secondFile, updateCommitCount, updateCommitMinConfidence, updateCommitSupport, updateCommitLift, updateCommitJaccardSimilarity) {
       MERGE (firstFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile)
         SET pairwiseChange.updateCommitCount             = toInteger(updateCommitCount)
            ,pairwiseChange.updateCommitMinConfidence     = updateCommitMinConfidence
            ,pairwiseChange.updateCommitSupport           = updateCommitSupport
            ,pairwiseChange.updateCommitLift              = updateCommitLift
            ,pairwiseChange.updateCommitJaccardSimilarity = updateCommitJaccardSimilarity
      } IN TRANSACTIONS OF 500 ROWS
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