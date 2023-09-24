// Community Detection Add LabelPropagationCommunity+Id label

 MATCH (member)
 WHERE member.labelPropagationCommunityId      IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member) 
  WITH member.labelPropagationCommunityId   AS communityId
      ,collect(member)            AS members
      ,count(DISTINCT member)     AS memberCount
      ,$dependencies_projection_node + 'LabelPropagationCommunity' + toString(member.labelPropagationCommunityId) AS labelName
 WHERE memberCount > 1
UNWIND members AS member
  CALL apoc.create.addLabels(member, [labelName]) YIELD node
RETURN count(node) AS nodesCount