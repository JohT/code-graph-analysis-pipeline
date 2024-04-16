// Set Incoming Package Dependencies including sub-packages

   MATCH (p:Java:Package)
    WITH *
        ,EXISTS{
            MATCH (p)<-[:CONTAINS]-(ancestor:Package)-[:CONTAINS]->(sibling:Package) 
            WHERE sibling <> p 
         } AS hasSiblingPackages
        ,EXISTS{(p)-[:CONTAINS]->(:Type)} AS containsTypes
    WHERE hasSiblingPackages OR containsTypes
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p)-[:CONTAINS*0..]->(sp:Package)-[:CONTAINS]->(st:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE NOT ep.fqn starts with p.fqn + '.'
     AND ep.fqn <> p.fqn
     // AND p.incomingDependenciesIncludingSubpackages IS NULL // comment out to recalculate
OPTIONAL MATCH (st)<-[:DEPENDS_ON]-(ei:Java:Type:Interface)
    WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
        ,p
        ,COUNT(et)              AS incomingDependencies
        ,SUM(r.weight)          AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)     AS incomingDependentTypes 
        ,COUNT(DISTINCT ei)     AS incomingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS incomingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
     SET p.incomingDependenciesIncludingSubpackages        = incomingDependencies
        ,p.incomingDependenciesWeightIncludingSubpackages  = incomingDependenciesWeight
        ,p.incomingDependentTypesIncludingSubpackages      = incomingDependentTypes
        ,p.incomingDependentInterfacesIncludingSubpackages = incomingDependentInterfaces
        ,p.incomingDependentPackagesIncludingSubpackages   = incomingDependentPackages
        ,p.incomingDependentArtifactsIncludingSubpackages  = incomingDependentArtifacts
  RETURN artifactName
        ,p.fqn  AS fullQualifiedPackageName
        ,p.name AS packageName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts