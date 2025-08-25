// Classify git commits and set properties like isMergeCommit, isAutomationCommit (=isBotCommit or isMavenCommit).

MATCH (git_commit:Git:Commit)
WITH git_commit,
     COUNT { (git_commit)-[:HAS_PARENT]->(:Git:Commit) } AS parentCount
WITH git_commit,
     parentCount >= 2                                    AS isMergeCommit,
     git_commit.author    CONTAINS '[bot]'               AS isBotAuthor,
     git_commit.message STARTS WITH '[maven'             AS isMavenCommit
WITH git_commit,
     isMergeCommit,
     isBotAuthor,
     isMavenCommit,
     (isBotAuthor OR isMavenCommit)                      AS isAutomatedCommit
SET git_commit.isMergeCommit     = isMergeCommit,
    git_commit.isBotAuthor       = isBotAuthor,
    git_commit.isMavenCommit     = isMavenCommit,
    git_commit.isAutomatedCommit = isAutomatedCommit,
    git_commit.isManualCommit    = NOT isAutomatedCommit
RETURN count(git_commit) AS classifiedCommits
// For Debugging:
//      ,isMergeCommit
//      ,isBotAuthor
//      ,isMavenCommit
//      ,isAutomatedCommit