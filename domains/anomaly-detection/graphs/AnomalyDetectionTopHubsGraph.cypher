// Anomaly Detection Graphs: Find top nodes marked as "hub" including their incoming dependencies and output them in Graphviz format.

// Step 1: Query overall statistics, e.g. min/max weight for later normalization
 MATCH (sourceForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics)
 WHERE $projection_node_label IN labels(sourceForStatistics)
   AND $projection_node_label IN labels(targetForStatistics)
  WITH min(coalesce(dependencyForStatistics.weight25PercentInterfaces, dependencyForStatistics.weight)) AS minWeight
      ,max(coalesce(dependencyForStatistics.weight25PercentInterfaces, dependencyForStatistics.weight)) AS maxWeight
// Step 2: Query direct dependencies to the target
 MATCH (source)-[directDependency:DEPENDS_ON]->(target)
 WHERE $projection_node_label IN labels(source)
   AND $projection_node_label IN labels(target)
   AND target.anomalyScore > 0
   AND target.anomalyHubRank = 1
ORDER BY directDependency.weight DESC
  WITH minWeight
      ,maxWeight
      ,target
      ,collect(source)           AS sources
      ,collect(directDependency) AS directDependencies
// Step 3: Query dependencies among sources
UNWIND sources AS source1
UNWIND sources AS source2
MATCH (source1)-[indirectDependency:DEPENDS_ON]->(source2)
  WITH minWeight
      ,maxWeight
      ,target
      ,directDependencies
      ,collect(indirectDependency) AS indirectDependencies
  WITH *, directDependencies + indirectDependencies AS allDependencies
// Step 4: Prepare results in GraphViz format for all dependencies
UNWIND allDependencies AS dependency
  WITH *, (endNode(dependency) = target)                                     AS isTargetEndNode
  WITH *, CASE WHEN isTargetEndNode THEN endNode(dependency) ELSE null END   AS targetEndNodeOrNull
  WITH *, CASE WHEN isTargetEndNode THEN null ELSE endNode(dependency) END   AS nonTargetEndNodeOrNull
  WITH *, coalesce(dependency.weight25PercentInterfaces, dependency.weight)  AS weight
  WITH *, toFloat(weight - minWeight) / toFloat(maxWeight - minWeight)       AS normalizedWeight
  WITH *, round((normalizedWeight * 5) + 1, 2)                               AS penWidth
  WITH *, "\\nhub #" + targetEndNodeOrNull.anomalyHubRank                    AS hubSubLabel
  WITH *, coalesce("\"hub\" [label=\"" + target.name + hubSubLabel + "\";]; ", "") AS hubNode         
  WITH *, "\"" + startNode(dependency).name + "\""                           AS sourceNode
  WITH *, coalesce("\"" + nonTargetEndNodeOrNull.name + "\"", "\"hub\"")     AS targetNode
  WITH *, " -> " + targetNode 
                 + " [label = "   + weight   + ";"
                 + " penwidth = " + penWidth + ";"
                 + " ];"                                                    AS graphVizDotNotationEdge
  WITH *, hubNode + sourceNode + coalesce(graphVizDotNotationEdge, " [];")  AS graphVizDotNotationLine
 ORDER BY target.anomalyHubRank DESC, target.name ASC
RETURN DISTINCT graphVizDotNotationLine
      //Debugging
      ,startNode(dependency).name AS sourceName
      ,endNode(dependency).name   AS targetName
      ,hubNode
      ,penWidth
      ,normalizedWeight
      ,dependency.weight          AS weight
      ,minWeight
      ,maxWeight
LIMIT 100