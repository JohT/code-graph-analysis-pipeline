// Create uniqueness constraint on symbol property for SemanticCodeIndexExternalSymbol nodes used in cross-file import mode.

CREATE CONSTRAINT scip_external_symbol_cross_file_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexExternalSymbol) REQUIRE n.symbol IS UNIQUE
