// Set incoming SCIP function dependencies. Requires "Import_SCIP_Function_Edges.cypher".

   MATCH (n:SCIP&SemanticCodeIndexFunction)
   WHERE n.incomingDependencies IS NULL
OPTIONAL MATCH (n)<-[r:DEPENDS_ON]-(source:SCIP&SemanticCodeIndexFunction|SCIP&SemanticCodeIndexInternalType|SCIP&SemanticCodeIndexExternalType)
   WHERE n <> source
    WITH n
        ,count(DISTINCT source.symbol) AS incomingDependencies
        ,sum(r.referenceCount)         AS incomingDependenciesWeight
     SET n.incomingDependencies       = incomingDependencies
        ,n.incomingDependenciesWeight = incomingDependenciesWeight
  RETURN n.fqn AS symbol
        ,incomingDependencies
