// Set incoming SCIP module dependencies aggregated from symbol-level DEPENDS_ON relationships.
// incomingDependencies = COUNT of symbol-level edges into symbols (types and functions) in this module.
// incomingDependenciesWeight = SUM of referenceCount (magnitude of those edges).
// incomingDependentModules = COUNT DISTINCT of modules that have symbols depending on this module's symbols.
// incomingDependentArtifacts = COUNT DISTINCT of artifacts that contain those dependent modules.

   MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(it:SemanticCodeIndexInternalSymbol)<-[symbolDependency:DEPENDS_ON]-(et:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(targetModule:SemanticCodeIndexModule)<-[:CONTAINS]-(sourceArtifact:SemanticCodeIndexArtifact)
   WHERE m <> targetModule
    WITH m
        ,count(DISTINCT symbolDependency)     AS incomingDependencies
        ,sum(symbolDependency.referenceCount) AS incomingDependenciesWeight
        ,count(DISTINCT et)                   AS distinctSourceSymbols
        ,count(DISTINCT targetModule)         AS distinctTargetModules
        ,count(DISTINCT sourceArtifact)       AS distinctSourceArtifacts
     SET m.incomingDependencies        = incomingDependencies
        ,m.incomingDependenciesWeight  = incomingDependenciesWeight
        ,m.incomingDependentModules    = distinctTargetModules
        ,m.incomingDependentArtifacts  = distinctSourceArtifacts
  RETURN m.fqn AS module
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,distinctSourceSymbols
        ,distinctTargetModules
        ,distinctSourceArtifacts