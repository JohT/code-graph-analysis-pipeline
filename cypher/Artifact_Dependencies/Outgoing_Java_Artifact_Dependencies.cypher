// Outgoing Artifact Dependencies

   MATCH (a:Java:Artifact:Archive)
OPTIONAL MATCH (a)-[r:DEPENDS_ON]->(ea:Artifact:Archive)
   WHERE a.fileName <> ea.fileName
    WITH a
        ,COUNT(ea)           AS outgoingDependencies
        ,SUM(r.weight)       AS outgoingDependenciesWeight
     SET a.outgoingDependencies       = outgoingDependencies
        ,a.outgoingDependenciesWeight = outgoingDependenciesWeight
  RETURN a.fileName
        ,outgoingDependencies
        ,outgoingDependenciesWeight