// List pair of files that were changed together and that have a declared dependency between each other.

MATCH (firstCodeFile:File)-[dependency:DEPENDS_ON]->(secondCodeFile:File)
MATCH (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
//De-duplicating the pairs of files isn't necessary, because the dependency relation is directed.
//WHERE elementId(firstCodeFile) < elementId(secondCodeFile)
 WITH  firstCodeFile.fileName       AS firstFileName
      ,secondCodeFile.fileName      AS secondFileName
      ,coalesce(dependency.weight, dependency.cardinality)    AS dependencyWeight
      ,pairwiseChange.commitCount   AS commitCount
      ,pairwiseChange.minConfidence AS minConfidence
      ,dependency.fileDistanceAsFewestChangeDirectoryCommands AS fileDistanceAsFewestChangeDirectoryCommands
RETURN dependencyWeight
      ,commitCount
      ,minConfidence
      ,fileDistanceAsFewestChangeDirectoryCommands
      // ,count(*)                    AS occurrences
      // ,collect(firstFileName + ' -> ' + secondFileName)[0..3] AS examples
ORDER BY dependencyWeight, commitCount