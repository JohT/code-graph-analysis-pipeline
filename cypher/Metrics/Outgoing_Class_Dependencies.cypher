//Outgoing Class Dependencies
   MATCH (p:Package)
MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)-[:DEPENDS_ON]->(eti:Interface)
   WHERE p <> ep
    WITH p, it
        ,COUNT(et)           AS outgoingDependencies
        ,SUM(r.weight)       AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)  AS outgoingDependentTypes 
        ,COUNT(DISTINCT eti) AS outgoingDependentInterfaces // included in usedTypes
        ,COUNT(DISTINCT ep)  AS outgoingDependentPackages
        ,COUNT(DISTINCT ea)  AS outgoingDependentArtifacts
   ORDER BY outgoingDependencies DESC
  RETURN p.fqn  AS packageName
        ,it.fqn AS className
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts
   LIMIT 50