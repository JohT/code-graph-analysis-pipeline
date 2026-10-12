// Set numberOfGitCommits property on code File nodes when aggregated change spans with grouped commits are present.

MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file:File&Git)
MATCH (git_file)<-[rel:CONTAINS_CHANGED]-(:Git:ChangeSpan)
 WITH code_file, toInteger(sum(rel.commits)) AS numberOfGitCommits
  SET code_file.numberOfGitCommits = numberOfGitCommits
RETURN count(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName)) AS changedCodeFiles