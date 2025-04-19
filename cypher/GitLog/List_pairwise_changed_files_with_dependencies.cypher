// List pair of files that were changed together and that have a declared dependency between each other.

MATCH (firstCodeFile:File)-[dependency:DEPENDS_ON]->(secondCodeFile:File)
MATCH (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
//De-duplicating the pairs of files isn't necessary, because the dependency relation is directed.
//WHERE elementId(firstCodeFile) < elementId(secondCodeFile)
 WITH  firstCodeFile.fileName      AS firstFileName
      ,secondCodeFile.fileName     AS secondFileName
      ,coalesce(dependency.weight, dependency.cardinality)    AS dependencyWeight
      ,pairwiseChange.commitCount  AS commitCount
      ,dependency.fileDistanceAsFewestChangeDirectoryCommands AS fileDistanceAsFewestChangeDirectoryCommands
RETURN dependencyWeight
      ,commitCount
      ,fileDistanceAsFewestChangeDirectoryCommands
      // ,count(*)                    AS occurrences
      // ,collect(firstFileName + ' -> ' + secondFileName)[0..3] AS examples
ORDER BY dependencyWeight, commitCount

// MATCH (firstCodeFile:File)-[dependency:DEPENDS_ON]->(secondCodeFile:File)
// MATCH (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
// WHERE elementId(firstCodeFile) < elementId(secondCodeFile)
// RETURN firstCodeFile.fileName  AS firstFileName
//       ,secondCodeFile.fileName AS secondFileName
//       ,dependency.weight           AS dependencyWeight
//       ,pairwiseChange.commitCount  AS commitCount
// ORDER BY dependencyWeight, commitCount

//  MATCH (g1:!Git&File)-[relation:CHANGED_TOGETHER_WITH|DEPENDS_ON]-(g2:!Git&File) 
//   WITH count(DISTINCT relation)   AS relatedFilesCount
//       ,collect(DISTINCT relation) AS relations
// UNWIND relations AS relation
//   WITH relatedFilesCount
//       ,coalesce(relation.commitCount, 0)                                 AS commitCount
//       ,coalesce(relation.weight, 0)                                      AS dependencyWeight
//       ,coalesce(relation.fileDistanceAsFewestChangeDirectoryCommands, 0) AS fileDistanceAsFewestChangeDirectoryCommands
// RETURN dependencyWeight
//       ,commitCount
//       ,fileDistanceAsFewestChangeDirectoryCommands
// ORDER BY dependencyWeight, commitCount
