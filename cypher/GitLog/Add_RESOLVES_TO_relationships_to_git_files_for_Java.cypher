// Connect git files to Java code files with a RESOLVES_TO relationship if their names match
// Note: Its quite tricky to match Java class file paths from inside e.g. *.jar files to their source repository file path reliable.
//       This could be improved by utilizing package manager data (like maven). Even that turns out to be not easy,
//       since the folder structure can be customized. Therefore, this is only a simplified attempt and by no means complete.
// Note: Even if is tempting to combine this file with the Typescript variant, they are intentionally separated.
//       The differences are subtle but need to be thought through and tested carefully.
//       Having separate files makes it obvious that there needs to be one for every new source code language.

MATCH (code_file:!Git&File)
WHERE  code_file.fileName IS NOT NULL
  // Use only original code files, no resolved duplicates
  AND NOT EXISTS { (code_file)-[:RESOLVES_TO]->(other_file:File&!Git) }
 WITH code_file
     ,replace(code_file.fileName, '.class', '.java') AS codeFileName
MATCH (git_file:Git&File)
 WITH *
     ,git_file
     ,coalesce(git_file.fileName, git_file.relativePath) AS gitFileName
WHERE gitFileName ENDS WITH codeFileName
MERGE (git_file)-[:RESOLVES_TO]->(code_file)
  SET git_file.resolved = true
RETURN count(DISTINCT codeFileName)  AS numberOfCodeFiles
      ,collect(DISTINCT codeFileName + ' <-> ' + gitFileName + '\n')[0..4] AS examples
// RETURN codeFileName, gitFileName
//       ,git_file.fileName, git_file.relativePath
//       ,git_repository.fileName , code_file.absoluteFileName
//       ,git_repository.name, code_file.fileName
// LIMIT 20