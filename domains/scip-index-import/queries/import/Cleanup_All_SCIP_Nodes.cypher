// Remove all SCIP-labeled nodes and their relationships from Neo4j. Ensures a clean slate for re-import.
// This replaces individual type node cleanup and removes orphaned modules, artifacts, and projects.

MATCH (node:SCIP)
DETACH DELETE node
