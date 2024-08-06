// Create index for git commit sha

CREATE INDEX INDEX_COMMIT_HASH IF NOT EXISTS FOR (commit:Commit) ON (commit.sha)