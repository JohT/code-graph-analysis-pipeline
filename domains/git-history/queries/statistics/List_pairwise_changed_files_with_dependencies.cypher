// List pair of files that were changed together and that have a declared dependency between each other. Requires Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher and Add_CHANGED_TOGETHER_WITH_relationships_to_code_files.cypher to run first.

MATCH (firstCodeFile:File)-[dependency:DEPENDS_ON]->(secondCodeFile:File)
MATCH (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
WHERE elementId(firstCodeFile) < elementId(secondCodeFile)
 WITH  firstCodeFile.fileName       AS firstFileName
      ,secondCodeFile.fileName      AS secondFileName
      ,coalesce(dependency.weight, dependency.cardinality)    AS dependencyWeight
      ,dependency.fileDistanceAsFewestChangeDirectoryCommands AS fileDistance
      ,pairwiseChange.updateCommitCount                       AS commitCount
      ,pairwiseChange.updateCommitMinConfidence               AS updateCommitMinConfidence
      ,pairwiseChange.updateCommitSupport                     AS updateCommitSupport
      ,pairwiseChange.updateCommitLift                        AS updateCommitLift
      ,pairwiseChange.updateCommitJaccardSimilarity           AS updateCommitJaccardSimilarity
RETURN dependencyWeight
      ,fileDistance
      ,commitCount
      ,updateCommitMinConfidence
      ,updateCommitSupport
      ,updateCommitLift
      ,updateCommitJaccardSimilarity
      // ,count(*)                    AS occurrences
      // ,collect(firstFileName + ' -> ' + secondFileName)[0..3] AS examples
ORDER BY dependencyWeight, commitCount