// Java Type-level detail edges within a specific Java Package feedback arc.
// Lists the individual Type-to-Type DEPENDS_ON relationships that make up a Package->Package feedback arc,
// to identify the actual low-level dependencies to refactor.
// Requires DEPENDS_ON relationships between Type nodes and Package CONTAINS Type relationships.
//
// Parameters:
//   $component_id   Integer id of the StronglyConnectedComponent node
//   $source_name    Fully qualified name of the source Java Package (e.g., "com.example.service")
//   $target_name    Fully qualified name of the target Java Package (e.g., "com.example.model")

MATCH (source:Package)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc:StronglyConnectedComponent {id: $component_id})
MATCH (target:Package)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc)
WHERE source.fqn = $source_name AND target.fqn = $target_name
MATCH (source)-[:CONTAINS]->(sourceType:Type)-[:DEPENDS_ON]->(targetType:Type)<-[:CONTAINS]-(target)
RETURN $component_id      AS componentId
      ,source.fqn         AS sourceModuleName
      ,target.fqn         AS targetModuleName
      ,sourceType.name    AS sourceDetailName
      ,targetType.name    AS targetDetailName
ORDER BY sourceType.name, targetType.name
