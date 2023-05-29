//Community Detection for Types 7 Add LeidenTypeCommunity+Id label to types
//with more than one member

 MATCH (type:Type) 
  WITH type.leidenTypeCommunityIdGamma7 AS communityId
      ,collect(type) AS types
      ,COUNT(DISTINCT type.fqn) AS members
      ,'LeidenTypeCommunity' + toString(type.leidenTypeCommunityIdGamma7) AS labelName
 WHERE members > 1
   AND communityId IS NOT NULL
UNWIND types AS type
//RETURN communityId, members, type
// LIMIT 10
  CALL apoc.create.addLabels(type, [labelName])
 YIELD node
RETURN node