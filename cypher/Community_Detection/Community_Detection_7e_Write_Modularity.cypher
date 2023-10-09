// Community Detection Write Modularity

CALL gds.modularity.stream(
 $dependencies_projection + '-without-empty', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
  WITH communityId, modularity
 MATCH (member)
 WHERE member[$dependencies_projection_write_property] = communityId
   AND $dependencies_projection_node IN LABELS(member)
  CALL apoc.create.setProperty(member, $dependencies_projection_write_property + 'Modularity', modularity)
 YIELD node
RETURN count(DISTINCT node) AS writtenModularityNodes;