// Set Incoming Package Dependencies
   MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)<-[:DEPENDS_ON]-(eti:Java:Type:Interface)
   WHERE p <> ep
     AND p.fqn <> ep.fqn
     AND p.incomingDependencies IS NULL // comment out to recalculate
    WITH p
        ,COUNT(et)           AS incomingDependencies
        ,SUM(r.weight)       AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)  AS incomingDependentTypes 
        ,COUNT(DISTINCT eti) AS incomingDependentInterfaces // also included in usedTypes
        ,COUNT(DISTINCT ep)  AS incomingDependentPackages
        ,COUNT(DISTINCT ea)  AS incomingDependentArtifacts
//ORDER BY incomingDependencies DESC, packageName ASC // uncomment to get most incoming first
     SET p.incomingDependencies        = incomingDependencies
        ,p.incomingDependenciesWeight  = incomingDependenciesWeight
        ,p.incomingDependentTypes      = incomingDependentTypes
        ,p.incomingDependentInterfaces = incomingDependentInterfaces
        ,p.incomingDependentPackages   = incomingDependentPackages
        ,p.incomingDependentArtifacts  = incomingDependentArtifacts
  RETURN p.fqn  AS packageName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts
