// Connect git files to SCIP source files with a RESOLVES_TO relationship if their paths match. Language-agnostic for all SCIP-supported languages. Requires SCIP:File nodes (Create_SCIP_File_Nodes.cypher) and Git:File nodes.

MATCH (code_file:SCIP:File)
WHERE code_file.relativePath IS NOT NULL
MATCH (git_file:Git:File)
WHERE git_file.name = code_file.name
  AND git_file.fileName ENDS WITH code_file.relativePath
  AND git_file.deletedAt IS NULL
ORDER BY git_file.createdAtEpoch DESC
 WITH *, size(split(git_file.fileName, '/'))                          AS gitFilePathElements
 WITH *, size(split(code_file.relativePath, '/'))                     AS scipFilePathElements
 WITH *, toFloat(scipFilePathElements) / toFloat(gitFilePathElements) AS pathMatchConfidence
 WITH *, gitFilePathElements - scipFilePathElements                   AS nonMatchingPathElements
 CALL { WITH git_file, code_file, nonMatchingPathElements, pathMatchConfidence
       MERGE (git_file)-[git_to_code_link:RESOLVES_TO]->(code_file)
          ON CREATE SET git_file.resolved  = true
                       ,git_to_code_link.nonMatchingPathElements = nonMatchingPathElements
                       ,git_to_code_link.pathMatchConfidence     = pathMatchConfidence
      } IN TRANSACTIONS OF 1000 ROWS
RETURN count(DISTINCT code_file.relativePath) AS numberOfScipFiles
      ,collect(DISTINCT code_file.relativePath + ' <-> ' + coalesce(git_file.fileName, git_file.relativePath) + '\n')[0..4] AS examples
