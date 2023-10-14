// Community Detection Modularity

CALL gds.alpha.modularity.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
RETURN communityId, modularity
ORDER BY communityId ASCENDING