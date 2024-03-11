// Outgoing Package Dependencies

   MATCH (p:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE ep.fqn <> p.fqn
OPTIONAL MATCH (it)-[:DEPENDS_ON]->(ei:Java:Type:Interface)
    WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
        ,p
        ,COUNT(et)              AS outgoingDependencies
        ,SUM(r.weight)          AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)     AS outgoingDependentTypes 
        ,COUNT(DISTINCT ei)    AS outgoingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS outgoingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS outgoingDependentArtifacts
   ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
  RETURN artifactName
        ,p.fqn  AS packageName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts
   LIMIT 50