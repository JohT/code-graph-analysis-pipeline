// Internal edges of the top N Strongly Connected Components (by complexity score) for a given node type.
// Used as input for Minimum Feedback Arc Set analysis in Python.
// Parameterized by node label and number of components to analyze.
// Requires StronglyConnectedComponent nodes created by StronglyConnectedComponent_CreateNode.cypher.
//
// Parameters:
//   $scc_node_type   Node label string of the analyzed code units (e.g., "Package", "SemanticCodeIndexModule")
//   $top_n_sccs      Maximum number of Strongly Connected Components to include (e.g., 5)

MATCH (scc:StronglyConnectedComponent)<-[:IN_STRONGLY_CONNECTED_COMPONENT]-(member)
WHERE scc.memberType = $scc_node_type AND scc.size > 1
WITH scc ORDER BY scc.complexityScore DESC, scc.size DESC
LIMIT $top_n_sccs
MATCH (source)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc)
MATCH (target)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(scc)
MATCH (source)-[dep:DEPENDS_ON]->(target)
WHERE source <> target
RETURN scc.id               AS componentId
      ,scc.name             AS componentName
      ,scc.size             AS componentSize
      ,scc.complexityScore  AS complexityScore
      ,scc.classification   AS classification
      ,coalesce(source.fqn, source.globalFqn, source.name) AS sourceName
      ,source.name          AS sourceShortName
      ,coalesce(target.fqn, target.globalFqn, target.name) AS targetName
      ,target.name          AS targetShortName
      ,coalesce(dep.referenceCount, dep.weight, 1)         AS weight
ORDER BY scc.complexityScore DESC, scc.id, weight DESC, sourceName, targetName
