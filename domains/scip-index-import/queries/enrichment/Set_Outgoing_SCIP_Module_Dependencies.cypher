// Set outgoing SCIP module dependencies aggregated from symbol-level DEPENDS_ON relationships.
// outgoingDependencies = COUNT of symbol-level edges from symbols (types and functions) in this module.
// outgoingDependenciesWeight = SUM of referenceCount (magnitude of those edges).
// outgoingDependentModules = COUNT DISTINCT of modules that contain symbols depended on by this module's symbols.
// outgoingDependentArtifacts = COUNT DISTINCT of artifacts that contain those dependent modules.

   MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(it:SemanticCodeIndexInternalSymbol)-[symbolDependency:DEPENDS_ON]->(et)<-[:CONTAINS]-(targetModule:SemanticCodeIndexModule)<-[:CONTAINS]-(targetArtifact:SemanticCodeIndexArtifact)
   WHERE m <> targetModule
    WITH m
        ,count(symbolDependency)              AS outgoingDependencies
        ,sum(symbolDependency.referenceCount) AS outgoingDependenciesWeight
        ,count(DISTINCT et)                   AS distinctTargetSymbols
        ,count(DISTINCT targetModule)         AS distinctTargetModules
        ,count(DISTINCT targetArtifact)       AS distinctTargetArtifacts
     SET m.outgoingDependencies        = outgoingDependencies
        ,m.outgoingDependenciesWeight  = outgoingDependenciesWeight
        ,m.outgoingDependentModules    = distinctTargetModules
        ,m.outgoingDependentArtifacts  = distinctTargetArtifacts
  RETURN m.fqn AS module
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,distinctTargetSymbols
        ,distinctTargetModules
        ,distinctTargetArtifacts
