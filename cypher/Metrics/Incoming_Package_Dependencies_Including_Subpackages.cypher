// Incoming Package Dependencies including sub-packages. Requires "Add_file_name and_extension.cypher".

   MATCH (p:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p:Package)-[:CONTAINS*0..]->(sp:Package)-[:CONTAINS]->(st:Java:Type)<-[r:DEPENDS_ON]-(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE NOT ep.fqn starts with p.fqn + '.'
     AND ep.fqn <> p.fqn
OPTIONAL MATCH (st)<-[:DEPENDS_ON]-(ei:Java:Type:Interface)
    WITH artifact.name AS artifactName
        ,p
        ,COUNT(et)              AS incomingDependencies
        ,SUM(r.weight)          AS incomingDependenciesWeight
        ,COUNT(DISTINCT et)     AS incomingDependentTypes 
        ,COUNT(DISTINCT ei)     AS incomingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS incomingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS incomingDependentArtifacts
        ,COUNT{(p)<-[:CONTAINS]-(:Package)-[:CONTAINS]->(:Package)} AS numberOfSiblingPackages
        ,COUNT{(p)<-[:CONTAINS]-(:Package)-[:CONTAINS]->(:Type)}    AS numberOfSiblingTypes
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
   WHERE (numberOfSiblingPackages > 0 OR numberOfSiblingTypes > 1)
  RETURN artifactName
        ,p.fqn  AS packageName
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,incomingDependentTypes
        ,incomingDependentInterfaces
        ,incomingDependentPackages
        ,incomingDependentArtifacts
 LIMIT 50