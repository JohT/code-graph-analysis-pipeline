// Set numberOfGitCommits property on code File nodes when git commits are present

MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file:File&Git)
MATCH (git_file)<-[:CONTAINS_CHANGED]-(git_commit:Git:Commit)
 WITH code_file, count(DISTINCT git_commit.hash) AS numberOfGitCommits
  SET code_file.numberOfGitCommits = numberOfGitCommits
RETURN count(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName)) AS changedCodeFiles
      //,collect(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName))[0..4] AS examples