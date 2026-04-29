// Overview of Leiden community detection results. Reads the communityLeidenId property written by communityCsv.sh.

MATCH (codeUnit)
WHERE codeUnit.communityLeidenId IS NOT NULL
WITH codeUnit.communityLeidenId AS communityId
    ,count(*)               AS communitySize
RETURN communityId
      ,communitySize
ORDER BY communitySize DESCENDING
LIMIT 30
