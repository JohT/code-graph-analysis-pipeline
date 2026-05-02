// Overview of Strongly Connected Components detection results. Reads the communityStronglyConnectedComponentId property written by communityCsv.sh.

MATCH (codeUnit)
WHERE codeUnit.communityStronglyConnectedComponentId IS NOT NULL
WITH codeUnit.communityStronglyConnectedComponentId AS componentId
    ,count(*)                                    AS componentSize
RETURN componentId
      ,componentSize
ORDER BY componentSize DESCENDING
LIMIT 30
