// Count CONTAINS_CHANGED relationships created during Pass 2b
// Should match the number of data rows in gitLog.csv (after deduplication)

MATCH ()-[rel:CONTAINS_CHANGED]->()
RETURN count(rel) AS relationshipCount
