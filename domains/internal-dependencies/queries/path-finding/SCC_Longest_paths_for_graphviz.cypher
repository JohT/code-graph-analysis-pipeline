// Path Finding - SCC-level Longest path - List top 100 edges for GraphViz visualization.
// Requires "SCC_TopologicalSort_Write.cypher". Operates on the SCC component graph
// (-components projection) so cyclic nodes appear as labelled Cycle components.
// Single-component nodes display their bare name; cycle components show size and representative name.

MATCH (sourceNodeForStatistics:StronglyConnectedComponent)
WHERE sourceNodeForStatistics.memberType = $dependencies_projection_node
OPTIONAL MATCH (sourceNodeForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetNodeForStatistics:StronglyConnectedComponent)
WHERE targetNodeForStatistics.memberType = $dependencies_projection_node
 WITH min(dependencyForStatistics[$dependencies_projection_weight_property]) AS minWeight
     ,max(dependencyForStatistics[$dependencies_projection_weight_property]) AS maxWeight
     ,max(sourceNodeForStatistics.topologicalSortMaxDistanceFromSource)      AS maxLevel
// 1E-38 is added to avoid division by zero in case all weights are equal
  WITH *, 1.0 / toFloat(maxWeight - minWeight) + 1E-38                       AS weightNormalizationFactor

CALL gds.dag.longestPath.stream($dependencies_projection + '-components')
YIELD index, totalCost, path
 WITH *, toInteger(totalCost) AS distance
      ,minWeight, maxWeight, maxLevel, weightNormalizationFactor
ORDER BY distance DESC, index ASC
UNWIND relationships(path) AS pathRelationship
 WITH *
     ,startNode(pathRelationship) AS startComponent
     ,endNode(pathRelationship)   AS endComponent
MATCH (startComponent)-[dependency:DEPENDS_ON]->(endComponent)
 WITH *, dependency[$dependencies_projection_weight_property] AS weight
 WITH *, toFloat(weight - minWeight) * weightNormalizationFactor AS normalizedWeight
 WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
// Node label: strip "Component " prefix for single nodes; annotate cycle size for cycles
 WITH *, CASE WHEN startComponent.size = 1
              THEN replace(startComponent.name, 'Component ', '')
              ELSE 'Cycle (' + startComponent.size + ')\\naround ' + replace(startComponent.name, 'Cycle around ', '')
         END AS startComponentLabel
 WITH *, CASE WHEN endComponent.size = 1
              THEN replace(endComponent.name, 'Component ', '')
              ELSE 'Cycle (' + endComponent.size + ')\\naround ' + replace(endComponent.name, 'Cycle around ', '')
         END AS endComponentLabel
// Level info uses topologicalSortMaxDistanceFromSource set on SCC component nodes
 WITH *, coalesce('\\n(level ' + startComponent.topologicalSortMaxDistanceFromSource + '/' + maxLevel + ')', '') AS startNodeLevelInfo
 WITH *, coalesce('\\n(level ' + endComponent.topologicalSortMaxDistanceFromSource + '/' + maxLevel + ')', '') AS endNodeLevelInfo
 WITH *, startComponentLabel + startNodeLevelInfo AS startNodeTitle
 WITH *, endComponentLabel   + endNodeLevelInfo   AS endNodeTitle
 WITH *, '[label=' + weight + '; penwidth=' + penWidth + '; ];' AS graphVizEdgeAttributes
 WITH *, '"' + startNodeTitle + '" -> "' + endNodeTitle + '" ' + graphVizEdgeAttributes AS graphVizDotNotationLine
RETURN graphVizDotNotationLine
LIMIT 100
