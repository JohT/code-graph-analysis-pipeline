// Create uniqueness constraint on symbol property for SemanticCodeIndexInternalSymbol nodes used in cross-file import mode.

CREATE CONSTRAINT scip_internal_symbol_cross_file_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexInternalSymbol) REQUIRE n.symbol IS UNIQUE
