// Overview of Weakly Connected Components detection results. Reads the communityWeaklyConnectedComponentId property written by communityCsv.sh.

MATCH (codeUnit)
WHERE codeUnit.communityWeaklyConnectedComponentId IS NOT NULL
WITH codeUnit.communityWeaklyConnectedComponentId AS componentId
    ,count(*)                                  AS componentSize
RETURN componentId
      ,componentSize
ORDER BY componentSize DESCENDING
LIMIT 30
