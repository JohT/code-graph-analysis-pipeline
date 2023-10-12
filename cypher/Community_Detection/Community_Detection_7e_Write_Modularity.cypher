// Community Detection Modularity Write

CALL gds.modularity.stream(
 $dependencies_projection + '-without-empty', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
  WITH collect({communityId: communityId, modularity: modularity}) AS modularities
 MATCH (member)
 WHERE member[$dependencies_projection_write_property] IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member)
  WITH modularities 
      ,member
      ,reduce(memberModularity = 0, modularity IN modularities | 
        CASE modularity.communityId WHEN member[$dependencies_projection_write_property] THEN modularity.modularity 
        ELSE memberModularity END)       AS memberModularity
  CALL apoc.create.setProperty(member, $dependencies_projection_write_property + 'Modularity', memberModularity)
 YIELD node
RETURN count(DISTINCT node) AS writtenModularityNodes