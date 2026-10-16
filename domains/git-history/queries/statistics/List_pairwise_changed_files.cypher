// List pairs of files that were changed together. Top 1000 by lift to keep output manageable. Requires Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher to run first.

MATCH (firstFile:Git:File)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondFile:Git:File)
WHERE firstFile.extension < secondFile.extension
   OR (firstFile.extension = secondFile.extension AND elementId(firstFile) < elementId(secondFile))
 WITH *
     ,coalesce(firstFile.relativePath, firstFile.fileName)    AS firstFileName
     ,coalesce(secondFile.relativePath, secondFile.fileName)  AS secondFileName
RETURN firstFileName
      ,secondFileName
      ,firstFile.name + '<br>' + secondFile.name              AS filePairLineBreak
      ,firstFileName + '<br>' + secondFileName                AS filePairWithRelativePathLineBreak
      ,firstFile.name + '↔' + secondFile.name                 AS filePair
      ,firstFileName + '↔' + secondFileName                   AS filePairWithRelativePath
      ,firstFile.extension                                    AS firstFileExtension
      ,secondFile.extension                                   AS secondFileExtension
      ,firstFile.extension + '↔' + secondFile.extension       AS fileExtensionPair
      ,pairwiseChange.updateCommitCount                       AS updateCommitCount
      ,pairwiseChange.updateCommitMinConfidence               AS updateCommitMinConfidence
      ,pairwiseChange.updateCommitSupport                     AS updateCommitSupport
      ,pairwiseChange.updateCommitLift                        AS updateCommitLift
      ,pairwiseChange.updateCommitJaccardSimilarity           AS updateCommitJaccardSimilarity
ORDER BY updateCommitLift DESC
LIMIT 1000