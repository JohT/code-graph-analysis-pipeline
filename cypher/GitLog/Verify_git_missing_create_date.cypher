// Verify that git to code file relationships aren't ambiguous

 MATCH (git_repository:Git&Repository)-[:HAS_FILE]->(git_file:Git&File&!Repository)
 WHERE git_file.deletedAt      IS NULL // Ignore deleted git files
   AND git_file.createdAtEpoch IS NULL
RETURN count(DISTINCT git_file) AS numberOfMissingCreateDateEntires