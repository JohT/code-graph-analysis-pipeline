// Overview of Leiden community detection results. Reads the communityLeidenId property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.communityLeidenId IS NOT NULL
WITH node.communityLeidenId AS communityId
    ,count(*)               AS communitySize
RETURN communityId
      ,communitySize
ORDER BY communitySize DESCENDING
LIMIT 30
