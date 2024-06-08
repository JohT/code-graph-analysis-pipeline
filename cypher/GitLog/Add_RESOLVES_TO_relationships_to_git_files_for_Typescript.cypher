// Connect git files to Typescript files with a RESOLVES_TO relationship if their names match
// Note: Even if is tempting to combine this file with the Java variant, they are intentionally spearated.
//       The differences are subtle but need to be thought through and tested carefully.
//       Having separate files makes it obvious that there needs to be one for every new source code language.

MATCH (code_file:File&!Git)
WHERE NOT EXISTS { (code_file)-[:RESOLVES_TO]->(other_file:File&!Git) } // only original nodes, no duplicates
 WITH code_file, code_file.absoluteFileName AS codeFileName
MATCH (git_file:File&Git)
WHERE codeFileName      ENDS WITH git_file.fileName
MERGE (git_file)-[:RESOLVES_TO]->(code_file)
  SET git_file.resolved = true
RETURN labels(code_file)[0..4]       AS codeFileLabels
      ,count(DISTINCT codeFileName)  AS numberOfCodeFiles
      ,collect(DISTINCT codeFileName + ' <-> ' + git_file.fileName + '\n')[0..4] AS examples