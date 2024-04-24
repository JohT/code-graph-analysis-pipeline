// Create directed projection for public Java methods filtering out constructors, getters and setters. Variables: dependencies_projection, dependencies_projection_weight_property

 MATCH (source:Java:Method)-[r:INVOKES]->(target:Java:Method)
 WHERE source.effectiveLineCount > 1
   AND target.effectiveLineCount > 1
   AND source.visibility = 'public'
   AND target.visibility = 'public'
   AND source.name <> '<init>'
   AND target.name <> '<init>'
  WITH gds.graph.project($dependencies_projection + '-cleaned', source, target) AS projection
RETURN projection.graphName         AS graphName
      ,projection.nodeCount         AS nodeCount
      ,projection.relationshipCount AS relationshipCount