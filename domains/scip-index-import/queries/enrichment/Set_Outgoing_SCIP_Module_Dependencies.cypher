// Set outgoing SCIP module dependencies. Mirrors type-level enrichment pattern. Requires "Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher".

   MATCH (m:SemanticCodeIndexModule)
   WHERE m.outgoingDependencies IS NULL
OPTIONAL MATCH (m)-[r:DEPENDS_ON]->(target:SemanticCodeIndexModule)
   WHERE m <> target
    WITH m
        ,count(DISTINCT target.fqn) AS outgoingDependencies
        ,sum(r.referenceCount)      AS outgoingDependenciesWeight
     SET m.outgoingDependencies       = outgoingDependencies
        ,m.outgoingDependenciesWeight = outgoingDependenciesWeight
  RETURN m.fqn AS module
        ,outgoingDependencies
