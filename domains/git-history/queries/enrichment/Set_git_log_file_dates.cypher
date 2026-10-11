// Compute createdAtEpoch (epoch ms from min A-type commit) and lastModificationAtEpoch (epoch ms from max commit) on Git:Log:File nodes.

MATCH (git_commit:Git:Log:Commit)-[r:CONTAINS_CHANGED]->(git_file:Git:Log:File)
 WITH git_file
     ,coalesce(min(CASE WHEN r.changeType = 'A' THEN git_commit.timestamp_unix END), min(git_commit.timestamp_unix)) AS minAddTimestamp
     ,max(git_commit.timestamp_unix)                                        AS maxTimestamp
  SET git_file.createdAtEpoch          = coalesce(minAddTimestamp * 1000, maxTimestamp * 1000, 0)
     ,git_file.lastModificationAtEpoch = coalesce(maxTimestamp * 1000, 0)
RETURN count(git_file) AS updatedFileCount
