//Set Outgoing Package Dependencies. Requires "Add_file_name_and_extension.cypher".

   MATCH (p:Java:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE p <> ep
     AND p.fqn <> ep.fqn
     // AND p.incomingDependencies IS NULL // comment out to recalculate
    WITH artifact.name AS artifactName 
        ,p
        ,COUNT(et)              AS outgoingDependencies
        ,SUM(r.weight)          AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)     AS outgoingDependentTypes 
        // Count interface types. They are also included in dependent types.
        ,COUNT{ MATCH (it)-[:DEPENDS_ON]->(eti:Java:Type:Interface) RETURN DISTINCT eti } AS outgoingDependentInterfaces
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
        ,p.fqn  AS fullQualifiedPackageName
        ,p.name AS packageName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts