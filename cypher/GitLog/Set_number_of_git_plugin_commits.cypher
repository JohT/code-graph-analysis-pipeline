// Set numberOfGitCommits property on code File nodes when git commits (detected by the plugin) are present

MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file:File&Git)
MATCH (git_file)<-[]-(:Git&Change)<-[:CONTAINS_CHANGE]-(git_commit:Git&Commit)
 WITH code_file, count(DISTINCT git_commit.sha) AS numberOfGitCommits
  SET code_file.numberOfGitCommits = numberOfGitCommits
RETURN count(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName)) AS changedCodeFiles
      //,collect(DISTINCT coalesce(code_file.absoluteFileName, code_file.fileName))[0..4] AS examples