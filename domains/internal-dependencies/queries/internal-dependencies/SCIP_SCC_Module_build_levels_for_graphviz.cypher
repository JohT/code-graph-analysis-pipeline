// List of all SCIP Semantic Index module SCC components and their dependencies with build levels for GraphViz Visualization.
// Requires "SCC_TopologicalSort_Write.cypher".

MATCH (sourceForStatistics:StronglyConnectedComponent)
WHERE sourceForStatistics.memberType = $dependencies_projection_node
  AND sourceForStatistics.topologicalSortMaxDistanceFromSource IS NOT NULL
OPTIONAL MATCH (sourceForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics:StronglyConnectedComponent)
WHERE targetForStatistics.memberType = $dependencies_projection_node
  AND targetForStatistics.topologicalSortMaxDistanceFromSource IS NOT NULL
 WITH min(dependencyForStatistics[$dependencies_projection_weight_property]) AS minWeight
     ,max(dependencyForStatistics[$dependencies_projection_weight_property]) AS maxWeight
     ,max(sourceForStatistics.topologicalSortMaxDistanceFromSource)          AS maxLevel
// 1E-38 prevents division by zero when all weights are equal
 WITH *, CASE WHEN minWeight = maxWeight THEN maxWeight + 1 ELSE maxWeight END AS maxWeight
MATCH (source:StronglyConnectedComponent)-[dependency:DEPENDS_ON]->(target:StronglyConnectedComponent)
WHERE source.memberType = $dependencies_projection_node
  AND target.memberType = $dependencies_projection_node
  AND source.topologicalSortMaxDistanceFromSource IS NOT NULL
  AND target.topologicalSortMaxDistanceFromSource IS NOT NULL
 WITH *, CASE WHEN maxWeight = minWeight THEN 0.0
              ELSE toFloat(dependency[$dependencies_projection_weight_property] - minWeight) / toFloat(maxWeight - minWeight)
         END AS normalizedWeight
 WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
// Single-member nodes: show bare module name; cycle nodes: annotate with cycle size and representative name
 WITH *, CASE WHEN source.size = 1
              THEN replace(source.name, 'Component ', '')
              ELSE 'Cycle (' + source.size + ')\\naround ' + replace(source.name, 'Cycle around ', '')
         END AS sourceLabel
 WITH *, CASE WHEN target.size = 1
              THEN replace(target.name, 'Component ', '')
              ELSE 'Cycle (' + target.size + ')\\naround ' + replace(target.name, 'Cycle around ', '')
         END AS targetLabel
 WITH *, "\\n(level " + coalesce(source.topologicalSortMaxDistanceFromSource + "/" + maxLevel, "?") + ")" AS sourceLevelInfo
 WITH *, "\\n(level " + coalesce(target.topologicalSortMaxDistanceFromSource + "/" + maxLevel, "?") + ")" AS targetLevelInfo
 WITH *, sourceLabel + sourceLevelInfo AS fullSourceName
 WITH *, targetLabel + targetLevelInfo AS fullTargetName
 WITH *, "\" -> \"" + fullTargetName
                  + "\" [label = "  + dependency[$dependencies_projection_weight_property] + ";"
                  + " penwidth = "  + penWidth + ";"
                  + " ];"    AS graphVizDotNotationEdge
 WITH *, "\"" + fullSourceName + coalesce(graphVizDotNotationEdge, "\" [];") AS graphVizDotNotationLine
ORDER BY dependency[$dependencies_projection_weight_property] DESC, target.topologicalSortMaxDistanceFromSource DESC
RETURN graphVizDotNotationLine
LIMIT 440
