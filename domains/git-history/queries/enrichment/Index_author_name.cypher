// Create index for author name (git data)

CREATE INDEX INDEX_AUTHOR_NAME IF NOT EXISTS FOR (n:Author) ON (n.name)