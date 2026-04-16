// List git files that where changed together frequently. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

MATCH (firstGitFile:Git&File&!Repository)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git&File&!Repository)
WHERE elementId(firstGitFile) < elementId(secondGitFile)
MATCH (gitRepository:Git&Repository)-[:HAS_FILE]->(firstGitFile)
MATCH (gitRepository:Git&Repository)-[:HAS_FILE]->(secondGitFile)
RETURN gitRepository.name + '/' + firstGitFile.relativePath  AS firstFile
      ,gitRepository.name + '/' + secondGitFile.relativePath AS secondFile
      ,gitChange.updateCommitCount                           AS commitCount
ORDER BY commitCount DESC
