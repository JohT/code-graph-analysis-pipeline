// Verify that git to code file relationships aren't ambiguous

MATCH (git_file:Git&File)-[:RESOLVES_TO]->(code_file:File&!Git)
OPTIONAL MATCH (git_file)<-[:HAS_FILE]-(git_repository:Git&Repository)
 WITH git_file
     ,git_repository
     ,count(*)                    AS numberOfResolvedCodeFiles
     ,collect(DISTINCT code_file) AS code_files
WHERE numberOfResolvedCodeFiles > 1
UNWIND code_files AS code_file
RETURN numberOfResolvedCodeFiles
      ,collect(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName))[0..4] AS codeFileExamples
      ,collect(DISTINCT coalesce(git_file.fileName, git_file.relativePath))[0..4]       AS gitFileExamples
      ,collect(DISTINCT git_repository.name)[0..4]                                      AS gitRepositoryExamples
      //,collect(git_repository)[0..9]
      //,collect(git_file)[0..9]
      //,collect(code_file)[0..9]