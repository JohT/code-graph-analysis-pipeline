 MATCH (:Artifact:Archive)-[dependencyForStatistics:DEPENDS_ON]->(:Artifact:Archive)
  WITH min(dependencyForStatistics.weight) AS minWeight
      ,max(dependencyForStatistics.weight) AS maxWeight
MATCH (source:Artifact:Archive)
OPTIONAL MATCH (source)-[dependency:DEPENDS_ON]->(target:Artifact:Archive)
//RETURN a, b, d
  WITH *, toFloat(dependency.weight - minWeight) / toFloat(maxWeight - minWeight) AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2) AS penWidth
  WITH *, source.name + '\\n(level ' + source.maxDistanceFromSource + ')' AS fullSourceName
  WITH *, target.name + '\\n(level ' + target.maxDistanceFromSource + ')' AS fullTargetName
  WITH *, "\" -> \"" + fullTargetName 
                   + "\" [label = "  + dependency.weight + ";"
                   + " penwidth = " + penWidth + ";"
                   + " ];"    AS graphVizDotNotationEdge
  WITH *, "\"" + fullSourceName + coalesce(graphVizDotNotationEdge, "\" [];") AS graphVizDotNotationLine
RETURN graphVizDotNotationLine
      //Debugging
      //,source.name       AS sourceName
      //,target.name       AS targetName
      //,penWidth
      //,normalizedWeight
      //,dependency.weight AS weight
      //,minWeight
      //,maxWeight