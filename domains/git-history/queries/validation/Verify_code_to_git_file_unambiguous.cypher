// Verify that code to git file relationships aren't ambiguous

MATCH (git_file:Git&File)-[:RESOLVES_TO]->(code_file:File&!Git)
 WITH code_file
     ,count(*)                    AS numberOfResolvedGitFiles
     ,collect(DISTINCT git_file)  AS git_files
WHERE numberOfResolvedGitFiles > 1
UNWIND git_files AS git_file
OPTIONAL MATCH (git_file)<-[:HAS_FILE]-(git_repository:Git&Repository)
RETURN numberOfResolvedGitFiles
      ,collect(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName))[0..4] AS codeFileExamples
      ,collect(DISTINCT coalesce(git_file.fileName, git_file.relativePath))[0..4]       AS gitFileExamples
      ,collect(DISTINCT git_repository.name)[0..4]                                      AS gitRepositoryExamples
      //,collect(git_repository)[0..9]
      //,collect(git_file)[0..9]
      //,collect(code_file)[0..9]