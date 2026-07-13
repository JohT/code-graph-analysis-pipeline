// Set outgoing SCIP type dependencies. Requires "Import_SCIP_Type_Edges.cypher".

   MATCH (n:SCIP&SemanticCodeIndexInternalType|SCIP&SemanticCodeIndexExternalType)
   WHERE n.outgoingDependencies IS NULL
OPTIONAL MATCH (n)-[r:DEPENDS_ON]->(target:SCIP&SemanticCodeIndexInternalType|SCIP&SemanticCodeIndexExternalType)
   WHERE n <> target
    WITH n
        ,count(DISTINCT target.symbol) AS outgoingDependencies
        ,sum(r.referenceCount)         AS outgoingDependenciesWeight
     SET n.outgoingDependencies       = outgoingDependencies
        ,n.outgoingDependenciesWeight = outgoingDependenciesWeight
  RETURN n.fqn AS symbol
        ,outgoingDependencies
