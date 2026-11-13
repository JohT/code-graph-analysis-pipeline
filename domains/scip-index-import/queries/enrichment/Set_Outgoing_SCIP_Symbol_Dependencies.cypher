// Set outgoing SCIP symbol dependencies. Requires "Import_SCIP_*_Edges.cypher".

   MATCH (n:SCIP&(SemanticCodeIndexInternalSymbol|SemanticCodeIndexExternalType))
   WHERE n.outgoingDependencies IS NULL
OPTIONAL MATCH (n)-[r:DEPENDS_ON]->(target:SCIP&(SemanticCodeIndexInternalSymbol|SemanticCodeIndexExternalType))
   WHERE n <> target
    WITH n
        ,count(DISTINCT target.symbol) AS outgoingDependencies
        ,sum(r.referenceCount)         AS outgoingDependenciesWeight
     SET n.outgoingDependencies       = outgoingDependencies
        ,n.outgoingDependenciesWeight = outgoingDependenciesWeight
  RETURN n.fqn AS symbol
        ,outgoingDependencies
