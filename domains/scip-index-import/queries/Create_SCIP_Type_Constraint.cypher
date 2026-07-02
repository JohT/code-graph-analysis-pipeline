// Create uniqueness constraint on symbol property for SCIPType nodes.

CREATE CONSTRAINT scip_type_symbol_unique IF NOT EXISTS
FOR (n:SCIPType) REQUIRE n.symbol IS UNIQUE
