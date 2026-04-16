// List code files not covered by imported git data for troubleshooting/testing.

 MATCH (code_file:File&!Git&!Directory)
 WHERE NOT EXISTS { (code_file)<-[:RESOLVES_TO]-(git_file:File&Git) }
RETURN reverse(split(reverse(code_file.fileName),'.')[0]) AS codeFileExtension
     ,labels(code_file)[0..2]                            AS firstThreeCodeFileLabels
     ,count(DISTINCT code_file.fileName)                 AS codeFileCount
     ,collect(DISTINCT code_file.fileName)[0..6]         AS codeFileExamples
LIMIT 50