// Community Detection Add LeidenCommunity+Id label

 MATCH (member)
 WHERE member.leidenCommunityId      IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member) 
  WITH member.leidenCommunityId   AS communityId
      ,collect(member)            AS members
      ,count(DISTINCT member)     AS memberCount
      ,$dependencies_projection_node + 'LeidenCommunity' + toString(member.leidenCommunityId) AS labelName
 WHERE memberCount > 1
UNWIND members AS member
  CALL apoc.create.addLabels(member, [labelName]) YIELD node
RETURN count(node) AS nodesCount