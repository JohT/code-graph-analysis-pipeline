// Create index for the full qualified type name

CREATE INDEX INDEX_JAVA_FULL_QUALIFIED_NAME IF NOT EXISTS FOR (t:Type) ON (t.fqn)