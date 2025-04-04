// List git files that where frequently changed with another file. Requires "Add_CHANGED_TOGETHER_WITH_relationships_to_git_files".

MATCH (firstGitFile:Git&File&!Repository)-[gitChange:CHANGED_TOGETHER_WITH]-(secondGitFile:Git&File&!Repository)
MATCH (gitRepository:Git&Repository)-[:HAS_FILE]->(firstGitFile)
UNWIND gitChange.commitHashes AS commitHash
RETURN gitRepository.name + '/' + firstGitFile.relativePath AS filePath
      ,count(DISTINCT commitHash)                           AS commitCount
ORDER BY commitCount DESC