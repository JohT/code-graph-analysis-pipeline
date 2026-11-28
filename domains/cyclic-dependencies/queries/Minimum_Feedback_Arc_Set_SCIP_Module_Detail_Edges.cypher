// SCIP symbol-level detail edges within a specific SCIP module feedback arc.
// Lists the individual SemanticCodeIndexInternalSymbol DEPENDS_ON relationships that make up
// a SemanticCodeIndexModule->SemanticCodeIndexModule feedback arc, to identify the actual
// low-level symbol dependencies to refactor.
// Requires DEPENDS_ON relationships between SemanticCodeIndexInternalSymbol nodes.
//
// Parameters:
//   $component_id   Integer id of the StronglyConnectedComponent node
//   $source_name    Fully qualified name of the source SCIP module (e.g., "src/textual/css")
//   $target_name    Fully qualified name of the target SCIP module (e.g., "src/textual")

MATCH (source:SemanticCodeIndexModule)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc:StronglyConnectedComponent {id: $component_id})
MATCH (target:SemanticCodeIndexModule)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc)
WHERE source.fqn = $source_name AND target.fqn = $target_name
MATCH (source)-[:CONTAINS]->(sourceSymbol:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(targetSymbol:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(target)
RETURN $component_id      AS componentId
      ,source.fqn         AS sourceModuleName
      ,target.fqn         AS targetModuleName
      ,sourceSymbol.name  AS sourceDetailName
      ,targetSymbol.name  AS targetDetailName
ORDER BY sourceSymbol.name, targetSymbol.name
