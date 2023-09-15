// Community Detection 8 Check Leiden Community Id

MATCH (a:Artifact) WHERE a.leidenCommunityId IS NOT NULL RETURN a.leidenCommunityId LIMIT 1