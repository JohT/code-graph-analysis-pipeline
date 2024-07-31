// Create index for the name for Typescript nodes

CREATE INDEX INDEX_TYPESCRIPT_NAME IF NOT EXISTS FOR (typescript:TS) ON (typescript.name)