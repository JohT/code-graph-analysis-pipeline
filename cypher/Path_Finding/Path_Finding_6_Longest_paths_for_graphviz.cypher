// Path Finding - Longest path - Stream - Find the top 100 dependencies contributing to the longest paths for Visualization with GraphViz

 MATCH (sourceNodeForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetNodeForStatistics)
 WHERE $dependencies_projection_node IN LABELS(sourceNodeForStatistics)
   AND $dependencies_projection_node IN LABELS(targetNodeForStatistics)
  WITH min(dependencyForStatistics[$dependencies_projection_weight_property]) AS minWeight
      ,max(dependencyForStatistics[$dependencies_projection_weight_property]) AS maxWeight
      ,max(targetNodeForStatistics.maxDistanceFromSource)                     AS maxLevel
   WITH *, 1.0 / toFloat(maxWeight - minWeight)  AS weightNormalizationFactor
  CALL gds.dag.longestPath.stream($dependencies_projection + '-cleaned')
 YIELD index, totalCost, path
  WITH *, toInteger(totalCost) AS distance
 ORDER BY distance DESC, index ASC
 UNWIND relationships(path) AS pathRelationship
  WITH *
      ,startNode(pathRelationship) AS startNode
      ,endNode(pathRelationship)   AS endNode
 MATCH (startNode)-[dependency:DEPENDS_ON]->(endNode)
  WITH *, dependency[$dependencies_projection_weight_property] AS weight
  WITH *, toFloat(weight - minWeight) * weightNormalizationFactor AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
  WITH *, startNode.name + "\\n(level " + startNode.maxDistanceFromSource + "/" + maxLevel + ")" AS startNodeTitle
  WITH *, endNode.name   + "\\n(level " + endNode.maxDistanceFromSource + "/" + maxLevel + ")"   AS endNodeTitle
  WITH *, "[label=" + weight  + "; penwidth=" + penWidth + "; ];"    AS graphVizEdgeAttributes
  WITH *, "\"" + startNodeTitle +  "\" -> \"" + endNodeTitle + "\" " + graphVizEdgeAttributes    AS graphVizDotNotationLine
RETURN graphVizDotNotationLine
// Debugging
// RETURN startNode.name        AS startNodeName
//       ,endNode.name          AS endNodeName
//       ,dependency[$dependencies_projection_weight_property] AS dependencyWeight
//       ,max(distance)         AS partOfLongestPathLength
//       ,count(DISTINCT index) AS partOfLongestPathCounts
//       ,startNode.maxDistanceFromSource AS startNodeLevel
//       ,endNode.maxDistanceFromSource   AS endNodeLevel
LIMIT 100