//   Incoming Class Dependencies
   MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)<-[:DEPENDS_ON]-(eti:Java:Type:Interface)
   WHERE p <> ep
    WITH p, it
        ,COUNT(et)           AS incomingDependencies
        ,SUM(r.weight)       AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)  AS incomingDependentTypes 
        ,COUNT(DISTINCT eti) AS incomingDependentInterfaces // also included in usedTypes
        ,COUNT(DISTINCT ep)  AS incomingDependentPackages
        ,COUNT(DISTINCT ea)  AS incomingDependentArtifacts
   ORDER BY incomingDependencies DESC
  RETURN p.fqn  AS packageName
        ,it.fqn AS className
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts
   LIMIT 50