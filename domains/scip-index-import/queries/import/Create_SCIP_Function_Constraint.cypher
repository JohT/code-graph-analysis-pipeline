// Create uniqueness constraint on symbol property for SemanticCodeIndexFunction nodes.

CREATE CONSTRAINT scip_function_symbol_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexFunction) REQUIRE n.symbol IS UNIQUE
