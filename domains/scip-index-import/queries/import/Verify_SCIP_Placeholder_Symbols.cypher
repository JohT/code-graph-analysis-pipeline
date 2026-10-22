// Verify SCIP type symbols for unresolved Maven/Gradle placeholders like ${...}. These indicate version mismatches between defining and consuming modules during multi-module SCIP merges, potentially creating shadow ExternalType nodes. Returns count of nodes with placeholders.

MATCH (scip:SCIP:SemanticCodeIndexInternalType)
WHERE scip.symbol CONTAINS '${'
WITH COUNT(DISTINCT scip) AS nodeCount
RETURN nodeCount
      ,CASE WHEN nodeCount > 0 THEN 'unresolved_placeholders' ELSE 'none' END AS placeholderType
