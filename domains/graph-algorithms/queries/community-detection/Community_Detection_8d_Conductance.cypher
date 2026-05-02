// Community Detection Conductance

CALL gds.conductance.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD community, conductance
RETURN community, conductance
ORDER BY community ASCENDING