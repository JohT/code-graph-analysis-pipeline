// Count Git:Log:Author nodes created during aggregated git log import

MATCH (a:Git:Log:Author)
RETURN count(a) AS authorCount