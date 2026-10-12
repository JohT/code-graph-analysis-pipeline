// Create index for change span month (aggregated git data)

CREATE INDEX INDEX_CHANGE_SPAN_MONTH IF NOT EXISTS FOR (n:ChangeSpan) ON (n.month)