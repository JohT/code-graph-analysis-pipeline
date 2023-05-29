// Compare Community Detection Results
MATCH (package:Package)
RETURN DISTINCT package.louvainCommunityId, package.leidenCommunityId, collect(package.fqn) AS packages
ORDER BY package.leidenCommunityId