// Create uniqueness constraint on fqn (project root) for SemanticCodeIndexProject nodes. Required before importing project nodes.

CREATE CONSTRAINT scip_project_fqn_unique IF NOT EXISTS
FOR (n:SemanticCodeIndexProject) REQUIRE n.fqn IS UNIQUE
