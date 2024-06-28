// Connect git files to code files with a RESOLVES_TO relationship if their names match
// Note: Even if is tempting to combine this file with the Typescript variant, they are intentionally spearated.
//       The differences are subtle but need to be thought through and tested carefully.
//       Having separate files makes it obvious that there needs to be one for every new source code language.

MATCH (code_file:File&!Git)
WHERE NOT EXISTS { (code_file)-[:RESOLVES_TO]->(other_file:File&!Git) } // only original nodes, no duplicates
 WITH code_file, replace(code_file.fileName, '.class', '.java') AS codeFileName
MATCH (git_file:File&Git)
WHERE git_file.fileName ENDS WITH codeFileName
MERGE (git_file)-[:RESOLVES_TO]->(code_file)
  SET git_file.resolved = true
RETURN count(DISTINCT codeFileName)  AS numberOfCodeFiles
      ,collect(DISTINCT codeFileName + ' <-> ' + git_file.fileName + '\n')[0..4] AS examples