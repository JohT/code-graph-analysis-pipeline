// Connect git files to Typescript files with a RESOLVES_TO relationship if their names match
// Note: Even if is tempting to combine this file with the Java variant, they are intentionally separated.
//       The differences are subtle but need to be thought through and tested carefully.
//       Having separate files makes it obvious that there needs to be one for every new source code language.

MATCH (code_file:!Git&File&!Directory&!Scan)
WHERE (code_file.absoluteFileName IS NOT NULL OR code_file.fileName IS NOT NULL)
 WITH code_file
     ,coalesce(code_file.absoluteFileName, code_file.fileName) AS codeFileName
MATCH (git_file:Git&File)
WHERE codeFileName      ENDS WITH git_file.fileName
   OR codeFileName      ENDS WITH git_file.relativePath
// Use repository if available to overcome ambiguity in multi source analysis
OPTIONAL MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file)
 WITH *
     ,git_repository
     ,git_file
     ,coalesce(coalesce(git_repository.fileName + '/', '')  + git_file.fileName
              ,coalesce(git_repository.name + '/', '')      + git_file.relativePath
      ) AS gitFileName
WHERE codeFileName      ENDS WITH gitFileName
 CALL { WITH git_file, code_file
       MERGE (git_file)-[:RESOLVES_TO]->(code_file)
          ON CREATE SET git_file.resolved = true
      } IN TRANSACTIONS
RETURN count(DISTINCT codeFileName)  AS numberOfCodeFiles
      ,collect(DISTINCT codeFileName + ' <-> ' + gitFileName + '\n')[0..4] AS examples
// RETURN codeFileName, gitFileName
//       ,git_file.fileName, git_file.relativePath
//       ,git_repository.fileName , code_file.absoluteFileName
//       ,git_repository.name, code_file.fileName
// LIMIT 20