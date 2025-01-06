// List of all Java Artifacts and their dependencies with build levels for GraphViz Visualization

 MATCH (sourceForStatistics:Java:Artifact)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics:Java:Artifact)
 WHERE sourceForStatistics.maxDistanceFromSource IS NOT NULL
   AND targetForStatistics.maxDistanceFromSource IS NOT NULL
  WITH min(dependencyForStatistics.weight) AS minWeight
      ,max(dependencyForStatistics.weight) AS maxWeight
      ,max(targetForStatistics.maxDistanceFromSource) AS maxLevel
 MATCH (source:Java:Artifact)-[dependency:DEPENDS_ON]->(target:Java:Artifact)
 WHERE source.maxDistanceFromSource IS NOT NULL
   AND target.maxDistanceFromSource IS NOT NULL
  WITH *, toFloat(dependency.weight - minWeight) / toFloat(maxWeight - minWeight) AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
  WITH *, source.name + "\\n(level " + coalesce(source.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS fullSourceName
  WITH *, target.name + "\\n(level " + coalesce(target.maxDistanceFromSource + "/" + maxLevel, "?") + ")" AS fullTargetName
  WITH *, "\" -> \"" + fullTargetName 
                   + "\" [label = "  + dependency.weight + ";"
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
      //,dependency.weight AS weight
      //,minWeight
      //,maxWeight
LIMIT 440