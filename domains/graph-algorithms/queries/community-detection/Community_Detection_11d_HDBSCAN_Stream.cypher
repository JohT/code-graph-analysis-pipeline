// Community Detection: Hierarchical Density-Based Spatial Clustering (HDBSCAN) - Stream

CALL gds.hdbscan.stream(
 $dependencies_projection + '-cleaned', {
    nodeProperty: $dependencies_projection_node_embeddings_property,
    samples: 3
})
 YIELD nodeId, label
  WITH gds.util.asNode(nodeId) AS member
      ,label
  WITH member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,label
  WITH count(DISTINCT member)       AS memberCount
      ,collect(DISTINCT memberName) AS memberNames
      ,label
RETURN memberCount
      ,label
      ,memberNames
 ORDER BY memberCount DESC, label ASC