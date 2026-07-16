// Remove all SemanticCodeIndexInternalType and SemanticCodeIndexExternalType nodes and their relationships from Neo4j. Run before re-importing to start with a clean slate.

MATCH (node:SemanticCodeIndexInternalType|SemanticCodeIndexExternalType)
DETACH DELETE node
