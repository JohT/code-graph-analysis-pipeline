// Set incoming SCIP symbol dependencies. Requires "Import_SCIP_*_Edges.cypher".

   MATCH (n:SCIP&(SemanticCodeIndexInternalSymbol|SemanticCodeIndexExternalType))
   WHERE n.incomingDependencies IS NULL
OPTIONAL MATCH (n)<-[r:DEPENDS_ON]-(source:SCIP&(SemanticCodeIndexInternalSymbol|SemanticCodeIndexExternalType))
   WHERE n <> source
    WITH n
        ,count(DISTINCT source.symbol) AS incomingDependencies
        ,sum(r.referenceCount)         AS incomingDependenciesWeight
     SET n.incomingDependencies       = incomingDependencies
        ,n.incomingDependenciesWeight = incomingDependenciesWeight
  RETURN n.fqn AS symbol
        ,incomingDependencies
