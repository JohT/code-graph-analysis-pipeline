// Redirect DEPENDS_ON edges from shadow ExternalType nodes to their InternalType counterparts.
// Multi-module SCIP imports create shadow nodes for cross-module references. This query redirects edges using
// the pre-computed "descriptor" property (last SCIP symbol token, e.g. "com/example/Foo#"), which works
// across all languages (Java FQN, Go/Python with backticks, TypeScript module paths) because SCIP uses
// space-delimited symbol format. Run before "Delete_SCIP_Shadow_External_Types.cypher".

MATCH (shadowExternalType:SCIP:SemanticCodeIndexExternalType)
MATCH (canonicalInternalType:SCIP:SemanticCodeIndexInternalType)
WHERE canonicalInternalType.descriptor = shadowExternalType.descriptor
MATCH (sourceType)-[dependsOnEdge:DEPENDS_ON]->(shadowExternalType)
WITH sourceType, canonicalInternalType, dependsOnEdge, dependsOnEdge.referenceCount AS edgeReferenceCount
  CALL { WITH sourceType, canonicalInternalType, edgeReferenceCount, dependsOnEdge
        DELETE dependsOnEdge
        MERGE (sourceType)-[redirectedEdge:DEPENDS_ON]->(canonicalInternalType)
          ON CREATE SET redirectedEdge.referenceCount = edgeReferenceCount
          ON MATCH  SET redirectedEdge.referenceCount = redirectedEdge.referenceCount + edgeReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN count(*) AS redirectedEdges
