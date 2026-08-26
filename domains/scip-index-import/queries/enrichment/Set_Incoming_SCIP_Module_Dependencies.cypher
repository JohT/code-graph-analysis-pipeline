// Set incoming SCIP module dependencies aggregated from type-level DEPENDS_ON relationships.
// incomingDependencies = COUNT of type-level edges into types in this module.
// incomingDependenciesWeight = SUM of referenceCount (magnitude of those edges).

   MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(it:SemanticCodeIndexInternalType)<-[typeDependency:DEPENDS_ON]-(et:SemanticCodeIndexInternalType)<-[:CONTAINS]-(targetModule:SemanticCodeIndexModule)
   WHERE m <> targetModule
    WITH m
        ,count(DISTINCT typeDependency)     AS incomingDependencies
        ,sum(typeDependency.referenceCount) AS incomingDependenciesWeight
        ,count(DISTINCT et)                 AS distinctSourceTypes
        ,count(DISTINCT targetModule)       AS distinctTargetModules
     SET m.incomingDependencies        = incomingDependencies
        ,m.incomingDependenciesWeight  = incomingDependenciesWeight
        ,m.incomingDependentModules    = distinctTargetModules
  RETURN m.fqn AS module
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,distinctSourceTypes
        ,distinctTargetModules