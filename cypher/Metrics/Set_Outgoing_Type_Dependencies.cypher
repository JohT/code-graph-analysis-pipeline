//Set Outgoing Type Dependencies

   MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(it:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
OPTIONAL MATCH (it)-[:DEPENDS_ON]->(eti:Type:Interface)
   WHERE it <> et
     AND it.fqn <> et.fqn
     AND it.outgoingDependencies IS NULL // comment out to recalculate
    WITH p.fqn                       AS packageName
        ,it
        ,it.fqn                      AS typeName
        ,count(DISTINCT et.fqn)      AS outgoingDependencies
        ,sum(r.weight)               AS outgoingDependenciesWeight
        ,count(DISTINCT eti.fqn)     AS outgoingDependentInterfaces // included in usedTypes
        ,count(DISTINCT ep.fqn)      AS outgoingDependentPackages
        ,count(DISTINCT ea.fileName) AS outgoingDependentArtifacts
// ORDER BY outgoingDependencies DESC // uncomment to get most outgoing first
     SET it.outgoingDependencies        = outgoingDependencies
        ,it.outgoingDependenciesWeight  = outgoingDependenciesWeight
        ,it.outgoingDependentInterfaces = outgoingDependentInterfaces
        ,it.outgoingDependentPackages   = outgoingDependentPackages
        ,it.outgoingDependentArtifacts  = outgoingDependentArtifacts
  RETURN packageName
        ,typeName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts