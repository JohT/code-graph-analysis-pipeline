//Set Outgoing Package Dependencies

   MATCH (p:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)-[:DEPENDS_ON]->(eti:Java:Type:Interface)
   WHERE p <> ep
     AND p.fqn <> ep.fqn
     // AND p.incomingDependencies IS NULL // comment out to recalculate
    WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName 
        ,p
        ,COUNT(et)              AS outgoingDependencies
        ,SUM(r.weight)          AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)     AS outgoingDependentTypes 
        ,COUNT(DISTINCT eti)    AS outgoingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS outgoingDependentPackages
        ,COUNT(DISTINCT ea)  -1 AS outgoingDependentArtifacts
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
     SET p.outgoingDependencies        = outgoingDependencies
        ,p.outgoingDependenciesWeight  = outgoingDependenciesWeight
        ,p.outgoingDependentTypes      = outgoingDependentTypes
        ,p.outgoingDependentInterfaces = outgoingDependentInterfaces
        ,p.outgoingDependentPackages   = outgoingDependentPackages
        ,p.outgoingDependentArtifacts  = outgoingDependentArtifacts
  RETURN artifactName
        ,p.fqn  AS packageName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts
