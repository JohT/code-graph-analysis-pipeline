// Create index for author email (git data)

CREATE INDEX INDEX_AUTHOR_EMAIL IF NOT EXISTS FOR (n:Author) ON (n.email)