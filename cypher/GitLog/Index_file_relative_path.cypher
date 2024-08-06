// Create index for the relative file path

CREATE INDEX INDEX_FILE_NAME IF NOT EXISTS FOR (file:File) ON (file.relativePath)