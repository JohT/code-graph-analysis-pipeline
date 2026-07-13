// Set outgoing SCIP artifact dependencies. Mirrors module-level enrichment. Requires "Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher".

   MATCH (a:SemanticCodeIndexArtifact)
OPTIONAL MATCH (a)-[r:DEPENDS_ON]->(target:SemanticCodeIndexArtifact)
   WHERE a <> target
    WITH a
        ,count(DISTINCT target.fqn) AS outgoingDependencies
        ,sum(r.referenceCount)      AS outgoingDependenciesWeight
     SET a.outgoingDependencies       = outgoingDependencies
        ,a.outgoingDependenciesWeight = outgoingDependenciesWeight
  RETURN a.fqn AS artifact
        ,outgoingDependencies
