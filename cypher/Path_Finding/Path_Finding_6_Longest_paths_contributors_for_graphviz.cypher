// Path Finding - Longest path - Stream - List all dependencies for nodes contributing to longest paths and highlight those paths in the Visualization with GraphViz.

// Gather global statistics about dependency weights and levels for normalization and node details
 MATCH (sourceNodeForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetNodeForStatistics)
 WHERE $dependencies_projection_node IN LABELS(sourceNodeForStatistics)
   AND $dependencies_projection_node IN LABELS(targetNodeForStatistics)
  WITH min(dependencyForStatistics[$dependencies_projection_weight_property]) AS minWeight
      ,max(dependencyForStatistics[$dependencies_projection_weight_property]) AS maxWeight
      ,max(targetNodeForStatistics.maxDistanceFromSource)                     AS maxLevel
   WITH *, 1.0 / toFloat(maxWeight - minWeight)                               AS weightNormalizationFactor
   WITH { minWeight: minWeight, maxLevel: maxLevel, weightNormalizationFactor: weightNormalizationFactor } AS statistics
// -> Main call to execute "longest path" algorithm
   CALL gds.dag.longestPath.stream($dependencies_projection + '-cleaned')
  YIELD index, totalCost, path
   WITH *
// Sort longest paths by their length descending and - if equal - by their index ascending
  ORDER BY totalCost DESC, index ASC
// Only take the top 50 longest paths as a compromise between performance and visualization content
  LIMIT 50
// Collect all results of the longest path search as well as all nodes of the longest paths
   WITH statistics
       ,collect({index: index, distance: toInteger(totalCost), path: path}) AS longestPaths
       ,collect(nodes(path)) AS allLongestPathNodes
// Flatten and deduplicate the list of all nodes that contribute to at least one longest path
 UNWIND allLongestPathNodes AS longestPathNodes
 UNWIND longestPathNodes    AS longestPathNode
   WITH statistics
       ,longestPaths
       ,collect(DISTINCT longestPathNode) AS allDistinctLongestPathNodes
// Iterate over all longest paths
 UNWIND longestPaths AS longestPath
   WITH statistics
       ,longestPaths, allDistinctLongestPathNodes
       ,[ singleRelationship IN relationships(longestPath.path)     | [startNode(singleRelationship), endNode(singleRelationship)] ] AS allLongestPathStartAndEndNodeTuples
       ,[ singleRelationship IN relationships(longestPaths[0].path) | [startNode(singleRelationship), endNode(singleRelationship)] ] AS longestPathStartAndEndNodeTuples
       ,longestPath.index       AS index
       ,longestPath.distance    AS distance
// -> Main query of all dependencies of nodes contributing to the longest paths
 MATCH (source)-[dependency:DEPENDS_ON]->(target)
 WHERE $dependencies_projection_node IN labels(source)
   AND $dependencies_projection_node IN labels(target)
   // Dependent nodes need to be part of at least one longest paths
   AND (source IN allDistinctLongestPathNodes AND target IN allDistinctLongestPathNodes)
  WITH statistics.maxLevel                  AS maxLevel
      ,statistics.minWeight                 AS minWeight
      ,statistics.weightNormalizationFactor AS weightNormalizationFactor
      ,count(index)                         AS numberOfLongestPathsPassing
      ,max(distance)                        AS lengthOfLongestPathPassing
      ,dependency
      ,source
      ,target
      // If there is at least one longest path passing through the dependency then "contributesToALongestPath" is true
      ,([source, target] IN allLongestPathStartAndEndNodeTuples)  AS contributesToALongestPath
      ,([source, target] IN longestPathStartAndEndNodeTuples)     AS isPartOfLongestPath
  WITH *, dependency[$dependencies_projection_weight_property]    AS weight
  WITH *, toFloat(weight - minWeight) * weightNormalizationFactor AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2)                    AS penWidth
  WITH *, source.name + "\\n(level " + source.maxDistanceFromSource + "/" + maxLevel + ")"    AS startNodeTitle
  WITH *, target.name   + "\\n(level " + target.maxDistanceFromSource + "/" + maxLevel + ")"  AS endNodeTitle
               // The longest path will be highlighted in red.
  WITH *, CASE WHEN isPartOfLongestPath       THEN "; color=\"red\"" 
               // Dependencies contributing to the longest path will be highlighted in dark orange.
               WHEN contributesToALongestPath THEN "; color=\"darkorange\"" 
          ELSE "" END AS edgeColor
// Prepare the GraphViz edge attributes for the visualization
  WITH *, "[label=" + weight  + "; penwidth=" + penWidth + edgeColor + "; ];" AS graphVizEdgeAttributes
// Assemble the final GraphViz DOT notation line for the edge representing the current dependency
  WITH *, "\"" + startNodeTitle +  "\" -> \"" + endNodeTitle + "\" " + graphVizEdgeAttributes AS graphVizDotNotationLine
RETURN DISTINCT graphVizDotNotationLine
// Debugging
//      ,source.name
//      ,target.name
//      ,numberOfLongestPathsPassing
//      ,lengthOfLongestPathPassing
//      ,contributesToALongestPath
//      ,isPartOfLongestPath
 LIMIT 440