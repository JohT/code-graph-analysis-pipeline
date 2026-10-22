// Delete ExternalType shadow nodes that have an InternalType counterpart with the same type descriptor. These shadows are created during multi-module SCIP import when cross-module references use a different version string than the defining module. Must run after "Redirect_SCIP_Shadow_Type_Edges_To_Internal.cypher".
//
// Descriptor Extraction: Extract the last space-separated token from SCIP symbols to identify shadow type pairs.
// This is language-agnostic because:
//   - Java: Last token is the FQN like "com/example/Foo#"
//   - Go/Python: Last token includes the package path like "`package.path`/TypeName#"
//   - Backtick-enclosed paths contain no spaces, so split by space safely isolates the final descriptor
// Type descriptor uniqueness is guaranteed within a project by SCIP's qualified symbol format.

MATCH (shadowExternalType:SCIP:SemanticCodeIndexExternalType)
WITH shadowExternalType, split(shadowExternalType.symbol, ' ')[-1] AS typeDescriptor
MATCH (canonicalInternalType:SCIP:SemanticCodeIndexInternalType)
WHERE split(canonicalInternalType.symbol, ' ')[-1] = typeDescriptor
  WITH shadowExternalType
  CALL { WITH shadowExternalType
        DETACH DELETE shadowExternalType
       } IN TRANSACTIONS OF 1000 ROWS
RETURN count(*) AS deletedNodes
