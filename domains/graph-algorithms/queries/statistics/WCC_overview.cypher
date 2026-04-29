// Overview of Weakly Connected Components detection results. Reads the communityWeaklyConnectedComponentId property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.communityWeaklyConnectedComponentId IS NOT NULL
WITH node.communityWeaklyConnectedComponentId AS componentId
    ,count(*)                                  AS componentSize
RETURN componentId
      ,componentSize
ORDER BY componentSize DESCENDING
LIMIT 30
