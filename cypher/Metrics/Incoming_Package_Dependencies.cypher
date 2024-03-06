// Incoming Package Dependencies

   MATCH (p:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE ep.fqn <> p.fqn
OPTIONAL MATCH (it)<-[:DEPENDS_ON]-(ei:Java:Type:Interface)
    WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
        ,p
        ,COUNT(et)              AS incomingDependencies
        ,SUM(r.weight)          AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)     AS incomingDependentTypes 
        ,COUNT(DISTINCT ei)     AS incomingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS incomingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
  RETURN artifactName
        ,p.fqn  AS packageName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts
   LIMIT 50