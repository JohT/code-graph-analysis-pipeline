// Create uniqueness constraint on symbol property for SemanticCodeIndexInternalType nodes.

CREATE CONSTRAINT scip_internal_type_symbol_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexInternalType) REQUIRE n.symbol IS UNIQUE
