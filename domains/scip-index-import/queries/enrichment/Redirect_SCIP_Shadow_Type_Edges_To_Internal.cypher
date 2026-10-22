// Redirect DEPENDS_ON edges from shadow ExternalType nodes to their InternalType counterparts. When multiple per-module SCIP indices are processed, cross-module type references produce ExternalType shadow nodes alongside the InternalType nodes from the defining module. This query redirects edges so Internal-to-Internal dependencies are preserved. Run before "Delete_SCIP_Shadow_External_Types.cypher".
//
// Descriptor Extraction: Extract the last space-separated token from SCIP symbols to match shadow and canonical types.
// This is language-agnostic because:
//   - Java: Last token is the FQN like "com/example/Foo#"
//   - Go/Python: Last token includes the package path like "`package.path`/TypeName#"
//   - Backtick-enclosed paths contain no spaces, so split by space safely isolates the final descriptor
// Type descriptor uniqueness is guaranteed within a project by SCIP's qualified symbol format.

MATCH (shadowExternalType:SCIP:SemanticCodeIndexExternalType)
WITH shadowExternalType, split(shadowExternalType.symbol, ' ')[-1] AS typeDescriptor
MATCH (canonicalInternalType:SCIP:SemanticCodeIndexInternalType)
WHERE split(canonicalInternalType.symbol, ' ')[-1] = typeDescriptor
MATCH (sourceType)-[dependsOnEdge:DEPENDS_ON]->(shadowExternalType)
WITH sourceType, canonicalInternalType, dependsOnEdge, dependsOnEdge.referenceCount AS edgeReferenceCount
  CALL { WITH sourceType, canonicalInternalType, edgeReferenceCount, dependsOnEdge
        DELETE dependsOnEdge
        MERGE (sourceType)-[redirectedEdge:DEPENDS_ON]->(canonicalInternalType)
          ON CREATE SET redirectedEdge.referenceCount = edgeReferenceCount
          ON MATCH  SET redirectedEdge.referenceCount = redirectedEdge.referenceCount + edgeReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN count(*) AS redirectedEdges
