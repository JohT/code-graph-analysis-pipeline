// Create uniqueness constraint on symbol property for SemanticCodeIndexType nodes.

CREATE CONSTRAINT scip_type_symbol_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexType) REQUIRE n.symbol IS UNIQUE
