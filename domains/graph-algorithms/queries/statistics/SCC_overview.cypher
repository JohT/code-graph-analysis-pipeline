// Overview of Strongly Connected Components detection results. Reads the communityStronglyConnectedComponentId property written by graphAlgorithmsCsv.sh.

MATCH (node)
WHERE node.communityStronglyConnectedComponentId IS NOT NULL
WITH node.communityStronglyConnectedComponentId AS componentId
    ,count(*)                                    AS componentSize
RETURN componentId
      ,componentSize
ORDER BY componentSize DESCENDING
LIMIT 30
