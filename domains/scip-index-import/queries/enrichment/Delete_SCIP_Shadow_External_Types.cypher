// Delete ExternalType shadow nodes that have an InternalType counterpart with the same type descriptor.
// Multi-module SCIP imports create shadows for cross-module references. This query uses the pre-computed
// "descriptor" property (last SCIP symbol token, e.g. "com/example/Foo#"), which works across all languages
// (Java FQN, Go/Python with backticks, TypeScript module paths) because SCIP uses space-delimited symbol format.
// Run after "Redirect_SCIP_Shadow_Type_Edges_To_Internal.cypher".

MATCH (shadowExternalType:SCIP:SemanticCodeIndexExternalType)
MATCH (canonicalInternalType:SCIP:SemanticCodeIndexInternalType)
WHERE canonicalInternalType.descriptor = shadowExternalType.descriptor
  WITH shadowExternalType
  CALL { WITH shadowExternalType
        DETACH DELETE shadowExternalType
       } IN TRANSACTIONS OF 1000 ROWS
RETURN count(*) AS deletedNodes
