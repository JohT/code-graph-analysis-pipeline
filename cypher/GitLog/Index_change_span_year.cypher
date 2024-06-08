// Create index for change span year (aggregated git data)

CREATE INDEX INDEX_CHANGE_SPAN_YEAR IF NOT EXISTS FOR (n:ChangeSpan) ON (n.year)