// Create uniqueness constraint on symbol property for SemanticCodeIndexExternalType nodes.

CREATE CONSTRAINT scip_external_type_symbol_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexExternalType) REQUIRE n.symbol IS UNIQUE