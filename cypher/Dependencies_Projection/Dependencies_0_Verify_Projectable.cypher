// Verify that nodes and relationships are complete and ready for projection

 MATCH (source:TS:Module)-[dependency:DEPENDS_ON]->(target:Module)
 WHERE $dependencies_projection_node            IN labels(source)
   AND $dependencies_projection_node            IN labels(target)
  WITH (NOT $dependencies_projection_weight_property IN keys(dependency)) AS missingWeightProperty
      ,(dependency[$dependencies_projection_weight_property])             AS weightPropertyValue
      ,(dependency[$dependencies_projection_weight_property] < 1)         AS nonPositiveWeightPropertyValue
      ,coalesce(dependency.resolved, false)                               AS resolvedDependency
      ,EXISTS { (target)<-[:IS_IMPLEMENTED_IN]-(resolvedTarget:ExternalModule) } AS resolvedTarget
      ,(source.incomingDependencies IS NULL OR
        target.incomingDependencies IS NULL)   AS missingIncomingDependencies
      ,(source.outgoingDependencies IS NULL OR 
        target.outgoingDependencies IS NULL)   AS missingOutgoingDependencies
      ,source
      ,target
 WHERE missingWeightProperty
//    OR nonPositiveWeightPropertyValue // if strict positive weights are needed 
    OR missingIncomingDependencies
    OR missingOutgoingDependencies
RETURN missingWeightProperty
      ,nonPositiveWeightPropertyValue
      ,resolvedDependency
      ,resolvedTarget
      ,missingIncomingDependencies
      ,missingOutgoingDependencies
      ,count(*) AS numberOfRelationships
      ,min(weightPropertyValue) AS minWeightPropertyValue
      ,max(weightPropertyValue) AS maxWeightPropertyValue
      ,collect(DISTINCT source.globalFqn + ' -> ' + target.globalFqn)[0..4] AS examples
      // Output source and target nodes for troubleshooting
      //,collect(source)[0..4]
      //,collect(target)[0..4]