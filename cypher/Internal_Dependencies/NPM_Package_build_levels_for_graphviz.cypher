// List of all NPM packages and their dependencies with build levels for GraphViz Visualization

 MATCH (sourceForStatistics:NPM:Package)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics:NPM:Package)
 WHERE sourceForStatistics.maxDistanceFromSource IS NOT NULL
   AND targetForStatistics.maxDistanceFromSource IS NOT NULL
  WITH min(dependencyForStatistics.weightByDependencyType) AS minWeight
      ,max(dependencyForStatistics.weightByDependencyType) AS maxWeight
      ,max(targetForStatistics.maxDistanceFromSource) AS maxLevel
 MATCH (source:NPM:Package)-[dependency:DEPENDS_ON]->(target:NPM:Package)
 WHERE source.maxDistanceFromSource IS NOT NULL
   AND target.maxDistanceFromSource IS NOT NULL
  WITH *, CASE
             WHEN maxWeight = minWeight THEN 0.0
             ELSE toFloat(dependency.weightByDependencyType - minWeight) / toFloat(maxWeight - minWeight)
           END AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
  WITH *, "\\n(level " + coalesce(source.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS sourceLevelInfo
  WITH *, "\\n(level " + coalesce(target.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS targetLevelInfo
  WITH *, CASE WHEN source:NpmDevPackage THEN "\\n[dev]" ELSE "" END AS sourceDevDependencyInfo
  WITH *, CASE WHEN target:NpmDevPackage THEN "\\n[dev]" ELSE "" END AS targetDevDependencyInfo
  WITH *, source.name + sourceLevelInfo + sourceDevDependencyInfo AS fullSourceName
  WITH *, target.name + targetLevelInfo + targetDevDependencyInfo AS fullTargetName
  WITH *, "\" -> \"" + fullTargetName 
                   + "\" [label = "  + dependency.weightByDependencyType + ";"
                   + " penwidth = "  + penWidth + ";"
                   + " ];"    AS graphVizDotNotationEdge
  WITH *, "\"" + fullSourceName + coalesce(graphVizDotNotationEdge, "\" [];") AS graphVizDotNotationLine
 ORDER BY dependency.weightByDependencyType DESC, target.maxDistanceFromSource DESC
RETURN graphVizDotNotationLine
      //Debugging
      //,source.name       AS sourceName
      //,target.name       AS targetName
      //,penWidth
      //,normalizedWeight
      //,dependency.weightByDependencyType AS weight
      //,minWeight
      //,maxWeight
LIMIT 440