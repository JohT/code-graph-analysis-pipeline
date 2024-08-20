// Connect git files to Typescript files with a RESOLVES_TO relationship if their names match
// Note: Even if is tempting to combine this file with the Java variant, they are intentionally separated.
//       The differences are subtle but need to be thought through and tested carefully.
//       Having separate files makes it obvious that there needs to be one for every new source code language.

MATCH (code_file:!Git&File)
WHERE (code_file.absoluteFileName IS NOT NULL OR code_file.fileName IS NOT NULL)
  // Use only original code files, no resolved duplicates
  AND NOT EXISTS { (code_file)-[:RESOLVES_TO]->(other_file:File&!Git) } 
 WITH code_file
     ,coalesce(code_file.absoluteFileName, code_file.fileName) AS codeFileName
MATCH (git_file:Git&File)
// Use repository if available to overcome ambiguity in multi source analysis
OPTIONAL MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
 WITH *
     ,git_repository
     ,git_file
     ,coalesce(coalesce(git_repository.fileName + '/', '')  + git_file.fileName
              ,coalesce(git_repository.name + '/', '')      + git_file.relativePath
      ) AS gitFileName
WHERE codeFileName      ENDS WITH gitFileName
MERGE (git_file)-[:RESOLVES_TO]->(code_file)
  SET git_file.resolved = true
RETURN count(DISTINCT codeFileName)  AS numberOfCodeFiles
      ,collect(DISTINCT codeFileName + ' <-> ' + gitFileName + '\n')[0..4] AS examples
// RETURN codeFileName, gitFileName
//       ,git_file.fileName, git_file.relativePath
//       ,git_repository.fileName , code_file.absoluteFileName
//       ,git_repository.name, code_file.fileName
// LIMIT 20