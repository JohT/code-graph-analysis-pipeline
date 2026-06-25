// Remove all SemanticCodeIndexType nodes and their relationships from Neo4j. Run before re-importing to start with a clean slate.

MATCH (node:SemanticCodeIndexType)
DETACH DELETE node
