// Set Incoming Type Dependencies

   MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)<-[:DEPENDS_ON]-(eti:Type:Interface)
   WHERE it <> et
     AND it.fqn <> et.fqn
     AND it.incomingDependencies IS NULL // comment out to recalculate
    WITH p.fqn                       AS packageName
        ,it
        ,it.fqn                      AS typeName
        ,count(DISTINCT et.fqn)      AS incomingDependencies 
        ,sum(r.weight)               AS incomingDependenciesWeight
        ,count(DISTINCT eti.fqn)     AS incomingDependentInterfaces // also included in usedTypes
        ,count(DISTINCT ep.fqn)      AS incomingDependentPackages
        ,count(DISTINCT ea.fileName) AS incomingDependentArtifacts
//   ORDER BY incomingDependencies DESC // uncomment to get most incoming first
     SET it.incomingDependencies        = incomingDependencies
        ,it.incomingDependenciesWeight  = incomingDependenciesWeight
        ,it.incomingDependentInterfaces = incomingDependentInterfaces
        ,it.incomingDependentPackages   = incomingDependentPackages
        ,it.incomingDependentArtifacts  = incomingDependentArtifacts
  RETURN packageName
        ,typeName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts