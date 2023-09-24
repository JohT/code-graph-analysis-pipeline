// Community Detection Add LouvainCommunity+Id label

 MATCH (member) 
 WHERE member.louvainCommunityId     IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member) 
  WITH member.louvainCommunityId  AS communityId
      ,collect(member)            AS members
      ,count(DISTINCT member)     AS memberCount
      ,$dependencies_projection_node + 'LouvainCommunity' + toString(member.louvainCommunityId) AS labelName
 WHERE memberCount > 1
UNWIND members AS member
  CALL apoc.create.addLabels(member, [labelName]) YIELD node
RETURN count(node) AS nodesCount