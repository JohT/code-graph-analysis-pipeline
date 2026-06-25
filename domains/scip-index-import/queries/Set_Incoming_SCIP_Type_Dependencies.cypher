// Set incoming SCIP type dependencies. Requires "Import_SCIP_Type_Edges.cypher".

   MATCH (n:SCIPType)
   WHERE n.incomingDependencies IS NULL
OPTIONAL MATCH (n)<-[r:DEPENDS_ON]-(source:SCIPType)
   WHERE n <> source
    WITH n
        ,count(DISTINCT source.symbol) AS incomingDependencies
        ,sum(r.referenceCount)         AS incomingDependenciesWeight
     SET n.incomingDependencies       = incomingDependencies
        ,n.incomingDependenciesWeight = incomingDependenciesWeight
  RETURN n.fqn AS symbol
        ,incomingDependencies
