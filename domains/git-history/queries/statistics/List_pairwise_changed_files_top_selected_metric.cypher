// Get the top 4 file extensions that where changed together most often and list top 20 pair that were changed together for each of the top file extension pair by their highest commit lift (>1: changes more often than by random chance). Requires Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher to run first.

MATCH (firstFile:Git:File)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile:Git:File)
WHERE firstFile.extension < secondFile.extension
   OR (firstFile.extension = secondFile.extension AND elementId(firstFile) < elementId(secondFile))
 WITH firstFile.extension + '↔' + secondFile.extension AS fileExtensionPair
     ,count(DISTINCT pairwiseChange)                   AS pairCount
ORDER BY pairCount DESC
 WITH collect(fileExtensionPair)[0..4]                 AS top4FileExtensionPairs
UNWIND top4FileExtensionPairs AS fileExtensionPair
CALL {
       WITH fileExtensionPair
      MATCH (firstFile:Git:File)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile:Git:File)
      WHERE elementId(firstFile) < elementId(secondFile)
        AND firstFile.extension + '↔' + secondFile.extension = fileExtensionPair
       WITH *
           ,coalesce(firstFile.relativePath, firstFile.fileName)   AS firstFileName
           ,coalesce(secondFile.relativePath, secondFile.fileName) AS secondFileName
     RETURN firstFile.name                                         AS firstFileNameShort
           ,secondFile.name                                        AS secondFileNameShort
           ,firstFileName
           ,secondFileName
           ,pairwiseChange[$selected_pair_metric]                  AS selectedMetric
           ,pairwiseChange.updateCommitLift                        AS updateCommitLift
           ,pairwiseChange.updateCommitCount                       AS updateCommitCount
           ,pairwiseChange.updateCommitMinConfidence               AS updateCommitMinConfidence
           ,pairwiseChange.updateCommitSupport                     AS updateCommitSupport
           ,pairwiseChange.updateCommitJaccardSimilarity           AS updateCommitJaccardSimilarity
      ORDER BY selectedMetric DESC, firstFileName ASC, secondFileName ASC
      LIMIT 20
}
RETURN fileExtensionPair
      ,firstFileNameShort
      ,secondFileNameShort
      ,updateCommitCount
      ,updateCommitMinConfidence
      ,updateCommitLift
      ,updateCommitJaccardSimilarity
      ,updateCommitSupport
      ,firstFileName
      ,secondFileName