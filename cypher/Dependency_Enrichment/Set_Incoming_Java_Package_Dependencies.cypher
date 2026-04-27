// Set Incoming Package Dependencies. Requires "Add_file_name and_extension.cypher".

   MATCH (p:Java:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)<-[:DEPENDS_ON]-(eti:Java:Type:Interface)
   WHERE p <> ep
     AND p.fqn <> ep.fqn
     // AND p.incomingDependencies IS NULL // comment out to recalculate
    WITH artifact.name AS artifactName
        ,p
        ,COUNT(et)               AS incomingDependencies
        ,SUM(r.weight)           AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)      AS incomingDependentTypes 
        ,COUNT(DISTINCT eti)     AS incomingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)      AS incomingDependentPackages
        ,COUNT(DISTINCT ea)  - 1 AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
     SET p.incomingDependencies        = incomingDependencies
        ,p.incomingDependenciesWeight  = incomingDependenciesWeight
        ,p.incomingDependentTypes      = incomingDependentTypes
        ,p.incomingDependentInterfaces = incomingDependentInterfaces
        ,p.incomingDependentPackages   = incomingDependentPackages
        ,p.incomingDependentArtifacts  = incomingDependentArtifacts
  RETURN artifactName
        ,p.fqn  AS fullQualifiedPackageName
        ,p.name AS packageName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts
