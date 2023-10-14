// Create directed projection for methods. Variables: dependencies_projection, dependencies_projection_weight_property

 MATCH (source:Method)-[r:INVOKES]->(target:Method)
 WHERE source.effectiveLineCount > 1
   AND target.effectiveLineCount > 1
   AND source.visibility = 'public'
   AND target.visibility = 'public'
   AND source.name <> '<init>'
   AND target.name <> '<init>'
  WITH gds.graph.project($dependencies_projection + '-without-empty', source, target) AS projection
RETURN projection.graphName         AS graphName
      ,projection.nodeCount         AS nodeCount
      ,projection.relationshipCount AS relationshipCount