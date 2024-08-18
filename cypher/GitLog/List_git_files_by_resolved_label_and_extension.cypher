// List resolved and unresolved git files by their extension

MATCH (git_file:Git&File)
OPTIONAL MATCH (git_file)-[:RESOLVES_TO]->(code_file:File&!Git)
  WITH git_file
      ,code_file
      ,(code_file IS NOT NULL)                                      AS resolved
      ,coalesce(git_file.fileName, git_file.relativePath)           AS gitFileName
RETURN  resolved
       ,reverse(split(split(reverse(gitFileName), '/')[0], '.')[0]) AS extension
       ,count(DISTINCT git_file)                                    AS gitFileCount
       ,coalesce(labels(code_file), labels(git_file))               AS fileLabels
       ,collect(DISTINCT gitFileName)[0..9]                         AS gitFileExamples
ORDER BY resolved ASC, gitFileCount DESC, extension ASC