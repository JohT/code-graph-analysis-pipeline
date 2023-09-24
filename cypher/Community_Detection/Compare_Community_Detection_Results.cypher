// Compare Community Detection Results

MATCH (package:Package)
 WITH package.louvainCommunityId    AS louvainCommunityId
     ,package.leidenCommunityId     AS leidenCommunityId
     ,collect(DISTINCT package.fqn) AS packages
     ,count(DISTINCT package.fqn)   AS packageCount
 WHERE louvainCommunityId IS NOT NULL
   AND leidenCommunityId IS NOT NULL
RETURN louvainCommunityId
      ,leidenCommunityId
      ,packageCount
      ,packages
ORDER BY packageCount DESC, louvainCommunityId ASC