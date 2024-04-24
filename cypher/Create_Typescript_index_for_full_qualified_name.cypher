// Create index for the full qualified type name

CREATE INDEX INDEX_TYPESCRIPT_FULL_QUALIFIED_NAME IF NOT EXISTS FOR (t:TS) ON (t.globalFqn)