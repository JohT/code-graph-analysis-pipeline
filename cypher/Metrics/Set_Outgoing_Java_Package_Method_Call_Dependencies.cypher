//Set Outgoing Package Method Call Dependencies

MATCH (p:Java:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(t:Java:Type)-[:DECLARES]->(m:Method)-[:INVOKES]->(dm:Method)<-[:DECLARES]-(dt:Java:Type)<-[:CONTAINS]-(dp:Package)<-[:CONTAINS]-(da:Artifact)
OPTIONAL MATCH (dm)<-[:DECLARES]-(dti:Interface)
WHERE p <> dp
 WITH p
     ,COUNT(dm)           AS outgoingMethodCalls
     ,COUNT(DISTINCT dm)  AS outgoingDistinctMethodCalls 
     ,COUNT(DISTINCT dt)  AS outgoingMethodCallTypes 
     ,COUNT(DISTINCT dti) AS outgoingMethodCallInterfaces
     ,COUNT(DISTINCT dp)  AS outgoingMethodCallPackages
     ,COUNT(DISTINCT da)  AS outgoingMethodCallArtifacts
   SET p.outgoingMethodCalls          = outgoingMethodCalls
      ,p.outgoingDistinctMethodCalls  = outgoingDistinctMethodCalls
      ,p.outgoingMethodCallTypes      = outgoingMethodCallTypes
      ,p.outgoingMethodCallInterfaces = outgoingMethodCallInterfaces
      ,p.outgoingMethodCallPackages   = outgoingMethodCallPackages
      ,p.outgoingMethodCallArtifacts  = outgoingMethodCallArtifacts
RETURN p.fqn AS packageName
      ,outgoingMethodCalls
      ,outgoingDistinctMethodCalls
      ,outgoingMethodCallTypes
      ,outgoingMethodCallInterfaces
      ,outgoingMethodCallPackages
      ,outgoingMethodCallArtifacts
ORDER BY outgoingMethodCalls DESC, packageName ASC