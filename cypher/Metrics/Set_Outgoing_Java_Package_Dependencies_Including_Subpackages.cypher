// Set Outgoing Package Dependencies including sub-packages

   MATCH (p:Java:Package)
    WITH *
        ,EXISTS{
            MATCH (p)<-[:CONTAINS]-(ancestor:Package)-[:CONTAINS]->(sibling:Package) 
            WHERE sibling <> p 
         } AS hasSiblingPackages
        ,EXISTS{(p)-[:CONTAINS]->(:Type)} AS containsTypes
    WHERE hasSiblingPackages OR containsTypes
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS*0..]->(sp:Package)-[:CONTAINS]->(st:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE NOT ep.fqn starts with p.fqn + '.'
     AND ep.fqn <> p.fqn
     // AND p.outgoingDependenciesIncludingSubpackages IS NULL // comment out to recalculate
OPTIONAL MATCH (st)<-[:DEPENDS_ON]-(ei:Java:Type:Interface)
    WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
        ,p
        ,COUNT(et)              AS outgoingDependencies
        ,SUM(r.weight)          AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)     AS outgoingDependentTypes 
        ,COUNT(DISTINCT ei)     AS outgoingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS outgoingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS outgoingDependentArtifacts
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
     SET p.outgoingDependenciesIncludingSubpackages        = outgoingDependencies
        ,p.outgoingDependenciesWeightIncludingSubpackages  = outgoingDependenciesWeight
        ,p.outgoingDependentTypesIncludingSubpackages      = outgoingDependentTypes
        ,p.outgoingDependentInterfacesIncludingSubpackages = outgoingDependentInterfaces
        ,p.outgoingDependentPackagesIncludingSubpackages   = outgoingDependentPackages
        ,p.outgoingDependentArtifactsIncludingSubpackages  = outgoingDependentArtifacts
  RETURN artifactName
        ,p.fqn  AS packageName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts