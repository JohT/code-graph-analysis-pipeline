// Take the already existing "CHANGED_TOGETHER_WITH" relationship between git files and apply it to resolved file nodes. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

MATCH (firstGitFile:Git&File&!Repository)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git&File&!Repository)
WHERE elementId(firstGitFile) < elementId(secondGitFile)
MATCH (firstGitFile)-[:RESOLVES_TO]->(firstCodeFile:File&!Git&!Repository)
MATCH (secondGitFile)-[:RESOLVES_TO]->(secondCodeFile:File&!Git&!Repository)
 CALL (firstCodeFile, secondCodeFile, gitChange) {
       MERGE (firstCodeFile)-[pairwiseChange:CHANGED_TOGETHER_WITH]-(secondCodeFile)
         SET pairwiseChange = properties(gitChange)
      } IN TRANSACTIONS
RETURN count(*) AS pairCount