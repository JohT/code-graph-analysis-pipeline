// Incoming Artifact Dependencies

   MATCH (a:Artifact:Archive)
OPTIONAL MATCH (a)<-[r:DEPENDS_ON]-(ea:Artifact:Archive)
   WHERE a.fileName <> ea.fileName
    WITH a
        ,COUNT(ea)           AS incomingDependencies
        ,SUM(r.weight)       AS incomingDependenciesWeight
     SET a.incomingDependencies        = incomingDependencies
        ,a.incomingDependenciesWeight  = incomingDependenciesWeight
  RETURN a.fileName
        ,incomingDependencies
        ,incomingDependenciesWeight