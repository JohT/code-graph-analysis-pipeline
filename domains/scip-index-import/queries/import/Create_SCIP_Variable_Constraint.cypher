// Create unique constraint on SemanticCodeIndexVariable.symbol to enforce single-valued symbol column.
CREATE CONSTRAINT unique_variable_symbol IF NOT EXISTS FOR (v:SemanticCodeIndexVariable) REQUIRE v.symbol IS UNIQUE
