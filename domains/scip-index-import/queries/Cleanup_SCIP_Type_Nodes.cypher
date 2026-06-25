// Remove all SCIPType nodes and their relationships from Neo4j. Run before re-importing to start with a clean slate.

MATCH (node:SCIPType)
DETACH DELETE node
