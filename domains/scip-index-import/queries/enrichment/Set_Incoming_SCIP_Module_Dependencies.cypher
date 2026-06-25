// Set incoming SCIP module dependencies. Mirrors type-level enrichment pattern. Requires "Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher".

   MATCH (m:SemanticCodeIndexModule)
   WHERE m.incomingDependencies IS NULL
OPTIONAL MATCH (m)<-[r:DEPENDS_ON]-(source:SemanticCodeIndexModule)
   WHERE m <> source
    WITH m
        ,count(DISTINCT source.fqn) AS incomingDependencies
        ,sum(r.referenceCount)      AS incomingDependenciesWeight
     SET m.incomingDependencies       = incomingDependencies
        ,m.incomingDependenciesWeight = incomingDependenciesWeight
  RETURN m.fqn AS module
        ,incomingDependencies
