// Set incoming SCIP artifact dependencies. Mirrors module-level enrichment. Requires "Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher".

   MATCH (a:SemanticCodeIndexArtifact)
   WHERE a.incomingDependencies IS NULL
OPTIONAL MATCH (a)<-[r:DEPENDS_ON]-(source:SemanticCodeIndexArtifact)
   WHERE a <> source
    WITH a
        ,count(DISTINCT source.fqn) AS incomingDependencies
        ,sum(r.referenceCount)      AS incomingDependenciesWeight
     SET a.incomingDependencies       = incomingDependencies
        ,a.incomingDependenciesWeight = incomingDependenciesWeight
  RETURN a.fqn AS artifact
        ,incomingDependencies
