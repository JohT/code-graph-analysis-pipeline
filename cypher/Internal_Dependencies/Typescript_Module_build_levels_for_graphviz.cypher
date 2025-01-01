// List of all Typescript modules and their dependencies with build levels for GraphViz Visualization

 MATCH (sourceForStatistics:TS:Module)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics:TS:Module)
 WHERE sourceForStatistics.maxDistanceFromSource IS NOT NULL
   AND targetForStatistics.maxDistanceFromSource IS NOT NULL
  WITH min(dependencyForStatistics.weight) AS minWeight
      ,max(dependencyForStatistics.weight) AS maxWeight
      ,max(targetForStatistics.maxDistanceFromSource) AS maxLevel
MATCH (source:TS:Module)-[dependency:DEPENDS_ON]->(target:TS:Module)
 WHERE source.maxDistanceFromSource IS NOT NULL
   AND target.maxDistanceFromSource IS NOT NULL
  WITH *, toFloat(dependency.cardinality - minWeight) / toFloat(maxWeight - minWeight) AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
  WITH *, source.rootProjectName + "\\n" + source.name + "\\n(level " + coalesce(source.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS fullSourceName
  WITH *, target.rootProjectName + "\\n" + target.name + "\\n(level " + coalesce(target.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS fullTargetName
  WITH *, "\" -> \"" + fullTargetName 
                   + "\" [label = "  + dependency.cardinality + ";"
                   + " penwidth = "  + penWidth + ";"
                   + " ];"    AS graphVizDotNotationEdge
  WITH *, "\"" + fullSourceName + coalesce(graphVizDotNotationEdge, "\" [];") AS graphVizDotNotationLine
 ORDER BY dependency.weight DESC, target.maxDistanceFromSource DESC
RETURN graphVizDotNotationLine
      //Debugging
      //,source.name       AS sourceName
      //,target.name       AS targetName
      //,penWidth
      //,normalizedWeight
      //,dependency.cardinality AS weight
      //,minWeight
      //,maxWeight
LIMIT 440