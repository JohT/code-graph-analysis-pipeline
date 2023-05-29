//Set Incoming Package Method Call Dependencies
MATCH (p:Package)
OPTIONAL MATCH (p)-[:CONTAINS]->(t:Java:Type)-[:DECLARES]->(m:Method)<-[:INVOKES]-(dm:Method)<-[:DECLARES]-(dt:Java:Type)<-[:CONTAINS]-(dp:Package)<-[:CONTAINS]-(da:Artifact)
OPTIONAL MATCH (dm)<-[:DECLARES]-(dti:Interface)
WHERE p <> dp
 WITH p
     ,COUNT(dm)           AS incomingMethodCalls
     ,COUNT(DISTINCT dm)  AS incomingDistinctMethodCalls 
     ,COUNT(DISTINCT dt)  AS incomingMethodCallTypes 
     ,COUNT(DISTINCT dti) AS incomingMethodCallInterfaces
     ,COUNT(DISTINCT dp)  AS incomingMethodCallPackages
     ,COUNT(DISTINCT da)  AS incomingMethodCallArtifacts
   SET p.incomingMethodCalls          = incomingMethodCalls
      ,p.incomingDistinctMethodCalls  = incomingDistinctMethodCalls
      ,p.incomingMethodCallTypes      = incomingMethodCallTypes
      ,p.incomingMethodCallInterfaces = incomingMethodCallInterfaces
      ,p.incomingMethodCallPackages   = incomingMethodCallPackages
      ,p.incomingMethodCallArtifacts  = incomingMethodCallArtifacts
RETURN p.fqn AS packageName
      ,incomingMethodCalls
      ,incomingDistinctMethodCalls
      ,incomingMethodCallTypes
      ,incomingMethodCallInterfaces
      ,incomingMethodCallPackages
      ,incomingMethodCallArtifacts
ORDER BY incomingMethodCalls DESC, packageName ASC