// Create index for the file name

CREATE INDEX INDEX_FILE_NAME IF NOT EXISTS FOR (t:File) ON (t.fileName)