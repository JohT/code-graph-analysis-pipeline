// List of all Typescript modules and their dependencies with build levels for GraphViz Visualization

 MATCH (sourceForStatistics:TS:Module)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics:TS:Module)
 WHERE sourceForStatistics.maxDistanceFromSource IS NOT NULL
   AND targetForStatistics.maxDistanceFromSource IS NOT NULL
  WITH min(dependencyForStatistics.cardinality) AS minCardinality
      ,max(dependencyForStatistics.cardinality) AS maxCardinality
      ,max(targetForStatistics.maxDistanceFromSource) AS maxLevel
  WITH *, CASE WHEN minCardinality = maxCardinality THEN maxCardinality + 1 ELSE maxCardinality END AS maxCardinality
 MATCH (source:TS:Module)-[dependency:DEPENDS_ON]->(target:TS:Module)
 WHERE source.maxDistanceFromSource IS NOT NULL
   AND target.maxDistanceFromSource IS NOT NULL
  WITH *, toFloat(dependency.cardinality - minCardinality) / toFloat(maxCardinality - minCardinality) AS normalizedCardinality
  WITH *, round((normalizedCardinality * 5) + 1, 2) AS penWidth
  WITH *, "\\n(level " + coalesce(source.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS sourceLevelInfo
  WITH *, "\\n(level " + coalesce(target.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS targetLevelInfo
  WITH *, source.rootProjectName + "\\n" + source.name + sourceLevelInfo AS fullSourceName
  WITH *, target.rootProjectName + "\\n" + target.name + targetLevelInfo AS fullTargetName
  WITH *, "\" -> \"" + fullTargetName 
                   + "\" [label = "  + dependency.cardinality + ";"
                   + " penwidth = "  + penWidth + ";"
                   + " ];"    AS graphVizDotNotationEdge
  WITH *, "\"" + fullSourceName + coalesce(graphVizDotNotationEdge, "\" [];") AS graphVizDotNotationLine
 ORDER BY dependency.cardinality DESC, target.maxDistanceFromSource DESC
RETURN graphVizDotNotationLine
      //Debugging
      //,source.name       AS sourceName
      //,target.name       AS targetName
      //,penWidth
      //,normalizedCardinality
      //,dependency.cardinality AS cardinality
      //,minCardinality
      //,maxCardinality
LIMIT 440