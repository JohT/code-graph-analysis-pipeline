// Set incoming SCIP module dependencies aggregated from type-level DEPENDS_ON relationships.
// incomingDependencies = COUNT of type-level edges into types in this module.
// incomingDependenciesWeight = SUM of referenceCount (magnitude of those edges).
// incomingDependentModules = COUNT DISTINCT of modules that have types depending on this module's types.
// incomingDependentArtifacts = COUNT DISTINCT of artifacts that contain those dependent modules.

   MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(it:SemanticCodeIndexInternalType)<-[typeDependency:DEPENDS_ON]-(et:SemanticCodeIndexInternalType)<-[:CONTAINS]-(targetModule:SemanticCodeIndexModule)<-[:CONTAINS]-(sourceArtifact:SemanticCodeIndexArtifact)
   WHERE m <> targetModule
    WITH m
        ,count(DISTINCT typeDependency)     AS incomingDependencies
        ,sum(typeDependency.referenceCount) AS incomingDependenciesWeight
        ,count(DISTINCT et)                 AS distinctSourceTypes
        ,count(DISTINCT targetModule)       AS distinctTargetModules
        ,count(DISTINCT sourceArtifact)     AS distinctSourceArtifacts
     SET m.incomingDependencies        = incomingDependencies
        ,m.incomingDependenciesWeight  = incomingDependenciesWeight
        ,m.incomingDependentModules    = distinctTargetModules
        ,m.incomingDependentArtifacts  = distinctSourceArtifacts
  RETURN m.fqn AS module
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,distinctSourceTypes
        ,distinctTargetModules
        ,distinctSourceArtifacts