// Path Finding - SCC-level Longest path contributors - Show all contributing dependencies in GraphViz.
// Requires "SCC_TopologicalSort_Write.cypher". Operates on the SCC component graph (-components
// projection). Highlights the single longest path in red; other contributors in dark orange.
// Cycle components are labelled with their size so readers can spot cyclic nodes immediately.

// Gather global statistics for weight normalization and level display
MATCH (sourceNodeForStatistics:StronglyConnectedComponent)
WHERE sourceNodeForStatistics.memberType = $dependencies_projection_node
OPTIONAL MATCH (sourceNodeForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetNodeForStatistics:StronglyConnectedComponent)
WHERE targetNodeForStatistics.memberType = $dependencies_projection_node
 WITH min(dependencyForStatistics[$dependencies_projection_weight_property]) AS minWeight
     ,max(dependencyForStatistics[$dependencies_projection_weight_property]) AS maxWeight
     ,max(sourceNodeForStatistics.topologicalSortMaxDistanceFromSource)      AS maxLevel
// 1E-38 is added to avoid division by zero in case all weights are equal
  WITH { minWeight: minWeight, maxLevel: maxLevel, weightNormalizationFactor: 1.0 / toFloat(maxWeight - minWeight) + 1E-38 } AS statistics

// Stream top 50 longest paths at SCC component level
CALL gds.dag.longestPath.stream($dependencies_projection + '-components')
YIELD index, totalCost, path
 WITH *
ORDER BY totalCost DESC, index ASC
LIMIT 50
 WITH statistics
     ,collect({index: index, distance: toInteger(totalCost), path: path}) AS longestPaths
     ,collect(nodes(path)) AS allLongestPathNodes
UNWIND allLongestPathNodes AS longestPathNodes
UNWIND longestPathNodes    AS longestPathNode
 WITH statistics
     ,longestPaths
     ,collect(DISTINCT longestPathNode) AS allDistinctLongestPathNodes
// Iterate over all top-50 longest paths to classify each dependency as contributor or part-of-longest
UNWIND longestPaths AS longestPath
 WITH statistics
     ,longestPaths, allDistinctLongestPathNodes
     ,[ singleRelationship IN relationships(longestPath.path)     | [startNode(singleRelationship), endNode(singleRelationship)] ] AS allLongestPathStartAndEndNodeTuples
     ,[ singleRelationship IN relationships(longestPaths[0].path) | [startNode(singleRelationship), endNode(singleRelationship)] ] AS longestPathStartAndEndNodeTuples
     ,longestPath.index    AS index
     ,longestPath.distance AS distance

// Find all component-level DEPENDS_ON edges whose endpoints contribute to at least one longest path
MATCH (source:StronglyConnectedComponent)-[dependency:DEPENDS_ON]->(target:StronglyConnectedComponent)
WHERE source.memberType = $dependencies_projection_node
  AND target.memberType = $dependencies_projection_node
  AND source IN allDistinctLongestPathNodes
  AND target IN allDistinctLongestPathNodes
 WITH statistics.maxLevel                  AS maxLevel
     ,statistics.minWeight                 AS minWeight
     ,statistics.weightNormalizationFactor AS weightNormalizationFactor
     ,count(index)                         AS numberOfLongestPathsPassing
     ,max(distance)                        AS lengthOfLongestPathPassing
     ,dependency
     ,source
     ,target
     ,([source, target] IN allLongestPathStartAndEndNodeTuples)  AS contributesToALongestPath
     ,([source, target] IN longestPathStartAndEndNodeTuples)     AS isPartOfLongestPath
 WITH *, dependency[$dependencies_projection_weight_property]    AS weight
 WITH *, toFloat(weight - minWeight) * weightNormalizationFactor AS normalizedWeight
 WITH *, round((normalizedWeight * 5) + 1, 2)                    AS penWidth
// Node label: strip "Component " prefix for single nodes; annotate cycle size for cycles
 WITH *, CASE WHEN source.size = 1
              THEN replace(source.name, 'Component ', '')
              ELSE 'Cycle (' + source.size + ')\\naround ' + replace(source.name, 'Cycle around ', '')
         END AS startComponentLabel
 WITH *, CASE WHEN target.size = 1
              THEN replace(target.name, 'Component ', '')
              ELSE 'Cycle (' + target.size + ')\\naround ' + replace(target.name, 'Cycle around ', '')
         END AS endComponentLabel
// Level info uses topologicalSortMaxDistanceFromSource set on SCC component nodes
 WITH *, coalesce('\\n(level ' + source.topologicalSortMaxDistanceFromSource + '/' + maxLevel + ')', '') AS startNodeLevelInfo
 WITH *, coalesce('\\n(level ' + target.topologicalSortMaxDistanceFromSource + '/' + maxLevel + ')', '') AS endNodeLevelInfo
 WITH *, startComponentLabel + startNodeLevelInfo AS startNodeTitle
 WITH *, endComponentLabel   + endNodeLevelInfo   AS endNodeTitle
               // The single longest path is highlighted in red.
 WITH *, CASE WHEN isPartOfLongestPath       THEN '; color="red"'
               // Dependencies that contribute to any of the top-50 longest paths are shown in dark orange.
              WHEN contributesToALongestPath THEN '; color="darkorange"'
         ELSE '' END AS edgeColor
 WITH *, '[label=' + weight + '; penwidth=' + penWidth + edgeColor + '; ];' AS graphVizEdgeAttributes
 WITH *, '"' + startNodeTitle + '" -> "' + endNodeTitle + '" ' + graphVizEdgeAttributes AS graphVizDotNotationLine
RETURN DISTINCT graphVizDotNotationLine
LIMIT 440
