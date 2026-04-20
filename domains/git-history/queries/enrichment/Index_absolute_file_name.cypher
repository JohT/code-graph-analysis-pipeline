// Create index for the absolute file name

CREATE INDEX INDEX_ABSOLUTE_FILE_NAME IF NOT EXISTS FOR (file:File) ON (file.absoluteFileName)