// Set numberOfGitUpdateCommits property on Git File nodes when git commits with Update modifier (detected by the plugin) are present

MATCH (git_file:File&Git)<-[:UPDATES]-(:Git&Change)<-[:CONTAINS_CHANGE]-(git_commit:Git&Commit)
 WITH git_file, count(DISTINCT git_commit.sha) AS numberOfGitUpdateCommits
  SET git_file.numberOfGitUpdateCommits = numberOfGitUpdateCommits
 WITH git_file, numberOfGitUpdateCommits
MATCH (code_file:File&!Git)<-[:RESOLVES_TO]-(git_file)
  SET code_file.numberOfGitUpdateCommits = numberOfGitUpdateCommits
RETURN count(DISTINCT code_file)                      AS codeFileUpdates
      ,collect(DISTINCT code_file.name)[0..4]         AS codeFileExample