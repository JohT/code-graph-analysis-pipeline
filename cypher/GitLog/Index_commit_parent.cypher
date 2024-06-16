// Create index for parent commit hash (git data)

CREATE INDEX INDEX_COMMIT_PARENT IF NOT EXISTS FOR (n:Commit) ON (n.parent)