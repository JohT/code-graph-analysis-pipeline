// Outgoing Package Dependencies including sub-packages. Requires "Add_file_name and_extension.cypher".

   MATCH (p:Package)
   MATCH (artifact:Artifact)-[:CONTAINS]->(p)
OPTIONAL MATCH (p:Package)-[:CONTAINS*0..]->(sp:Package)-[:CONTAINS]->(st:Java:Type)-[r:DEPENDS_ON]->(et:Java:Type)<-[:CONTAINS]-(ep:Package)<-[:CONTAINS]-(ea:Artifact)
   WHERE NOT ep.fqn starts with p.fqn + '.'
     AND ep.fqn <> p.fqn
OPTIONAL MATCH (st)<-[:DEPENDS_ON]-(ei:Java:Type:Interface)
    WITH artifact.name AS artifactName
        ,p
        ,COUNT(et)              AS outgoingDependencies
        ,SUM(r.weight)          AS outgoingDependenciesWeight
        ,COUNT(DISTINCT et)     AS outgoingDependentTypes 
        ,COUNT(DISTINCT ei)     AS outgoingDependentInterfaces // also included in dependent types
        ,COUNT(DISTINCT ep)     AS outgoingDependentPackages
        ,COUNT(DISTINCT ea) - 1 AS outgoingDependentArtifacts
        ,COUNT{(p)<-[:CONTAINS]-(:Package)-[:CONTAINS]->(:Package)} AS numberOfSiblingPackages
        ,COUNT{(p)<-[:CONTAINS]-(:Package)-[:CONTAINS]->(:Type)}    AS numberOfSiblingTypes
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first
   WHERE (numberOfSiblingPackages > 0 OR numberOfSiblingTypes > 1)
  RETURN artifactName
        ,p.fqn  AS packageName
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,outgoingDependentTypes
        ,outgoingDependentInterfaces
        ,outgoingDependentPackages
        ,outgoingDependentArtifacts
LIMIT 50