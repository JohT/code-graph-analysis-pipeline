// Community Detection Add WeaklyConnectedComponent+Id label

 MATCH (member)
 WHERE member.weaklyConnectedComponentId      IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member) 
  WITH member.weaklyConnectedComponentId   AS communityId
      ,collect(member)            AS members
      ,count(DISTINCT member)     AS memberCount
      ,$dependencies_projection_node + 'WeaklyConnectedComponent' + toString(member.weaklyConnectedComponentId) AS labelName
 WHERE memberCount > 1
UNWIND members AS member
  CALL apoc.create.addLabels(member, [labelName]) YIELD node
RETURN count(node) AS nodesCount