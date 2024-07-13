// List node labels and their relationship types, their count and their density.

 MATCH (nodeByLabel)
  WITH labels(nodeByLabel)  AS nodeLabels
      ,collect(nodeByLabel) AS nodesWithThatLabels
      ,count(nodeByLabel)   AS numberOfNodesWithThatLabels
UNWIND nodesWithThatLabels AS nodeWithThatLabels
 MATCH (nodeWithThatLabels)-[relation]->(target)
  WITH nodeLabels                  AS sourceLabels
      ,numberOfNodesWithThatLabels AS numberOfNodesWithSameLabelsAsSource
      ,type(relation)              AS relationType
      ,labels(target)              AS targetLabels
      ,count(DISTINCT relation)    AS numberOfRelationships
  WITH sourceLabels
      ,relationType
      ,targetLabels
      ,numberOfRelationships
      ,numberOfNodesWithSameLabelsAsSource
      ,count{ MATCH (targetWithLabel) WHERE labels(targetWithLabel) = targetLabels } AS numberOfNodesWithSameLabelsAsTarget
RETURN sourceLabels
      ,relationType
      ,targetLabels
      ,numberOfRelationships
      ,numberOfNodesWithSameLabelsAsSource
      ,numberOfNodesWithSameLabelsAsTarget
      ,toFloat(numberOfRelationships)
        / ( numberOfNodesWithSameLabelsAsSource * numberOfNodesWithSameLabelsAsTarget)
        * 100 AS densityInPercent
ORDER BY numberOfRelationships DESC