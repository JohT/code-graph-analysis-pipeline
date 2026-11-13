// Create uniqueness constraint on SCIP field symbols to ensure MERGE operations are correct.

CREATE CONSTRAINT IF NOT EXISTS FOR (field:SemanticCodeIndexField) REQUIRE field.symbol IS UNIQUE
