//Outgoing Package Dependencies
   MATCH (p:Package)
MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)-[:DEPENDS_ON]->(eti:Interface)
   WHERE p <> ep
    WITH p
        ,COUNT(et)           AS outgoingDependencies
        ,COUNT(DISTINCT et)  AS outgoingDependentTypes 
        ,COUNT(DISTINCT eti) AS outgoingDependentInterfaces // included in usedTypes
        ,COUNT(DISTINCT ep)  AS outgoingDependentPackages
        ,COUNT(DISTINCT ea)  AS outgoingDependentArtifacts
        ,SUM(r.weight)       AS outgoingDependenciesWeight
   ORDER BY outgoingDependencies DESC
  RETURN p.fqn  AS packageName
        ,outgoingDependencies
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts
        ,outgoingDependenciesWeight
   LIMIT 50