// Create index for commit hash (git data)

CREATE INDEX INDEX_COMMIT_HASH IF NOT EXISTS FOR (n:Commit) ON (n.hash)