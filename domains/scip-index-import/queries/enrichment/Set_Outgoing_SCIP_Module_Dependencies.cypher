// Set outgoing SCIP module dependencies aggregated from type-level DEPENDS_ON relationships.
// outgoingDependencies = COUNT of type-level edges from types in this module.
// outgoingDependenciesWeight = SUM of referenceCount (magnitude of those edges).

   MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(it:SemanticCodeIndexInternalType)-[typeDependency:DEPENDS_ON]->(et)<-[:CONTAINS]-(targetModule:SemanticCodeIndexModule)
   WHERE m <> targetModule
    WITH m
        ,count(typeDependency)              AS outgoingDependencies
        ,sum(typeDependency.referenceCount) AS outgoingDependenciesWeight
        ,count(DISTINCT et)                 AS distinctTargetTypes
        ,count(DISTINCT targetModule)       AS distinctTargetModules
     SET m.outgoingDependencies        = outgoingDependencies
        ,m.outgoingDependenciesWeight  = outgoingDependenciesWeight
        ,m.outgoingDependentModules    = distinctTargetModules
  RETURN m.fqn AS module
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,distinctTargetTypes
        ,distinctTargetModules
