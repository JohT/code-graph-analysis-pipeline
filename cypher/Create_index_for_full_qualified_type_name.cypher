// Create index for the full qualified type name

CREATE INDEX INDEX_FULL_QUALIFIED_TYPE_NAME IF NOT EXISTS FOR (t:Type) ON (t.fqn)