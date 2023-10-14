// Community Detection Stream Intermediate Mutated for hierarchical algorithmns (Louvain, Leiden)

CALL gds.graph.nodeProperty.stream(
     $dependencies_projection + '-cleaned'
    ,$dependencies_projection_write_property
)
 YIELD nodeId, propertyValue
  WITH gds.util.asNode(nodeId) AS member
      ,propertyValue           AS intermediateCommunityIds
  WITH member
      ,intermediateCommunityIds
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
  WITH intermediateCommunityIds
      ,count(DISTINCT member)         AS memberCount
      ,collect(DISTINCT memberName)   AS memberNames
RETURN intermediateCommunityIds[0]    AS firstCommunityId
      ,last(intermediateCommunityIds) AS communityId
      ,intermediateCommunityIds
      ,memberCount
      ,memberNames
 ORDER BY memberCount DESC, communityId ASC