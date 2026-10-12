// Count Git:Log:ChangeSpan nodes created during aggregated git log import

MATCH (s:Git:Log:ChangeSpan)
RETURN count(s) AS changeSpanCount