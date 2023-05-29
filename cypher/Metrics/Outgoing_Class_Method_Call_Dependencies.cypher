//Outgoing Class Method Call Dependencies
MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(t:Java:Type)-[:DECLARES]->(m:Method)-[:INVOKES]->(dm:Method)<-[:DECLARES]-(dt:Java:Type)<-[:CONTAINS]-(dp:Package)<-[:CONTAINS]-(da:Artifact)
OPTIONAL MATCH (dm)<-[:DECLARES]-(dti:Interface)
WHERE p <> dp
 WITH p, t
     ,COUNT(dm)           AS outgoingMethodCalls
     ,COUNT(DISTINCT dm)  AS outgoingDistinctMethodCalls 
     ,COUNT(DISTINCT dt)  AS outgoingMethodCallTypes 
     ,COUNT(DISTINCT dti) AS outgoingMethodCallInterfaces
     ,COUNT(DISTINCT dp)  AS outgoingMethodCallPackages
     ,COUNT(DISTINCT da)  AS outgoingMethodCallArtifacts
RETURN p.fqn AS packageName
      ,t.fqn AS className
      ,outgoingMethodCalls
      ,outgoingDistinctMethodCalls
      ,outgoingMethodCallTypes
      ,outgoingMethodCallInterfaces
      ,outgoingMethodCallPackages
      ,outgoingMethodCallArtifacts
ORDER BY outgoingMethodCalls DESC
 LIMIT 50