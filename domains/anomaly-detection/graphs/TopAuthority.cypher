// Anomaly Detection Graphs: Find top nodes marked as "Authority" including their incoming and outgoing dependencies, sizes based on PageRank and thick outline for nodes with high Page Rank to Article Rank difference in Graphviz format.

// Step 1: Query overall statistics, e.g. min/max weight for later normalization
 MATCH (sourceForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics)
 WHERE $projection_node_label IN labels(sourceForStatistics)
   AND $projection_node_label IN labels(targetForStatistics)
  WITH max(coalesce(dependencyForStatistics.weight25PercentInterfaces, dependencyForStatistics.weight)) AS maxWeight
      ,percentileDisc(sourceForStatistics.centralityPageRankToArticleRankDifference, 0.80) AS pageToArticleRankThreshold
      ,percentileDisc(targetForStatistics.centralityPageRankNormalized, 0.80)              AS pageRankThreshold
// Step 2: Query selected central node
 MATCH (central)
 WHERE $projection_node_label IN labels(central)
   AND central.anomalyAuthorityRank = toInteger($projection_node_rank)
  WITH maxWeight
      ,pageToArticleRankThreshold
      ,pageRankThreshold
      ,central
      ,"Top Rank #" + $projection_node_rank + " " + $projection_language + " " + $projection_node_label + " Authority\\n" AS graphLabel
      ,coalesce(central.fqn, central.globalFqn, central.fileName, central.signature, central.name)   AS targetName
  WITH *, "\\n\\ndark nodes: incoming dependencies (limited max. 40)\\n"                             AS graphLegend
  WITH *, graphLegend + "bright nodes: outgoing dependencies (limited max. 40)\\n"                   AS graphLegend
  WITH *, graphLegend + "node value: Page Rank (normalized)\\n"                                      AS graphLegend
  WITH *, graphLegend + "large circle: > 80% percentile of Page Rank\\n"                             AS graphLegend
  WITH *, graphLegend + "thick outline: > 80% percentile of Page Rank to Article Rank Difference\\n" AS graphLegend
  WITH *, ["graph   [label=\"" + graphLabel + targetName + graphLegend + "\\n\"];"]       AS graphVizOutput
  WITH *, "🏛️ authority #" + central.anomalyAuthorityRank + "\\n" + central.name          AS centralNodeLabel
  WITH *, graphVizOutput + ["central [label=\"" + centralNodeLabel + "\"];"]              AS graphVizOutput
// Step 3: Query direct incoming dependencies to the central node
 MATCH (source)-[dependency:DEPENDS_ON]->(central)
  WHERE $projection_node_label IN labels(source)
    AND source.outgoingDependencies > 0
  ORDER BY dependency.weight DESC, source.name ASC
  LIMIT 40
   WITH *, coalesce(dependency.weight25PercentInterfaces, dependency.weight, 1)  AS weight
   WITH *, round((toFloat(weight) / toFloat(maxWeight) * 2.5) + 0.4, 1.0)        AS penWidth
   WITH *, "label=" + weight + "; weight=" + weight + "; penwidth=" + penWidth   AS edgeAttributes
   WITH *, CASE WHEN source.centralityPageRankToArticleRankDifference >= pageToArticleRankThreshold 
                THEN 5 ELSE 2 END                                                AS scaledNodeBorder
   WITH *, CASE WHEN source.centralityPageRankNormalized >= pageRankThreshold 
                THEN "shape = \"circle\"; height=2; " ELSE "" END                AS nodeEmphasis
   WITH *, round(source.centralityPageRankNormalized * 100.0, 2) + "%"           AS labelValue
   // Add the last part of the element id to the node name to make it unique.
   WITH *, source.name + "_" + split(elementId(source), ':')[-1]                 AS sourceId
   WITH *, "penwidth = " + scaledNodeBorder + "; "                               AS directInBorder
   // Split long names like inner classes identified by a dollar sign ($)
   WITH *, replace(source.name, '$', '$\\n')                                     AS sourceNameSplit
   WITH *, "label = \"" + sourceNameSplit + "\\n(" + labelValue + ")\"; "        AS directInLabel
   WITH *, " [" + nodeEmphasis + directInLabel + directInBorder + "]; "          AS directInNodeProperties
   WITH *, "\"" + sourceId + "\" " + directInNodeProperties                      AS directInNode
   WITH maxWeight
       ,pageToArticleRankThreshold
       ,pageRankThreshold
       ,central
       ,graphVizOutput 
       ,collect(source) AS incomingDependencyNodes
       ,collect(directInNode + "\"" + sourceId + "\" -> central [" + edgeAttributes + "];") AS directInEdges
   WITH *, graphVizOutput + directInEdges AS graphVizOutput
// Step 4: Query direct outgoing dependencies from the central node
 MATCH (source)<-[dependency:DEPENDS_ON]-(central)
  WHERE $projection_node_label IN labels(source)
    AND source.incomingDependencies > 0
  ORDER BY dependency.weight DESC, source.name ASC
  LIMIT 40
   WITH *, coalesce(dependency.weight25PercentInterfaces, dependency.weight, 1)  AS weight
   WITH *, round((toFloat(weight) / toFloat(maxWeight) * 2.5) + 0.4, 1.0)        AS penWidth
   WITH *, "label=" + weight + "; weight=" + weight + "; penwidth=" + penWidth   AS edgeAttributes
   // Use a lighter color for the target nodes of outgoing dependencies from the central node and their edges
   WITH *, edgeAttributes + "; color = 5"                                        AS edgeAttributes
   WITH *, "color = 5; fillcolor = 1; "                                          AS directOutColor
   WITH *, CASE WHEN source.centralityPageRankToArticleRankDifference >= pageToArticleRankThreshold 
                THEN 5 ELSE 2 END                                                AS scaledNodeBorder
   WITH *, CASE WHEN source.centralityPageRankNormalized >= pageRankThreshold 
                THEN "shape = \"circle\"; height=2; " ELSE "" END                AS nodeEmphasis
   WITH *, round(source.centralityPageRankNormalized * 100.0, 2) + "%"           AS labelValue
   // Add the last part of the element id to the node name to make it unique.
   WITH *, source.name + "_" + split(elementId(source), ':')[-1]                 AS sourceId
   WITH *, "penwidth = " + scaledNodeBorder + "; "                               AS directOutBorder
   // Split long names like inner classes identified by a dollar sign ($)
   WITH *, replace(source.name, '$', '$\\n')                                     AS sourceNameSplit
   WITH *, "label = \"" + sourceNameSplit + "\\n(" + labelValue + ")\"; "        AS directOutLabel
   WITH *, " [" + nodeEmphasis + directOutLabel + directOutBorder + directOutColor + "]; " AS directOutNodeProperties
   WITH *, "\"" + sourceId + "\" " + directOutNodeProperties                     AS directOutNode
   WITH maxWeight
       ,central
       ,graphVizOutput
       ,incomingDependencyNodes
       ,collect(source) AS outgoingDependencyNodes
       ,collect(directOutNode + "central -> \"" + sourceId + "\" [" + edgeAttributes + "];") AS directOutEdges
   WITH *, graphVizOutput + directOutEdges                   AS graphVizOutput
   WITH *, incomingDependencyNodes + outgoingDependencyNodes AS directDependentNodes
// Step 5: Query dependencies between direct dependencies outside the central node
 UNWIND directDependentNodes AS directDependentNode
  MATCH (directDependentNode)-[dependency:DEPENDS_ON]->(anotherDirectDependentNode)
  WHERE anotherDirectDependentNode IN directDependentNodes
    AND anotherDirectDependentNode <> directDependentNode
  ORDER BY dependency.weight DESC, directDependentNode.name ASC
   WITH graphVizOutput 
       ,directDependentNode
       ,dependency
       ,collect(anotherDirectDependentNode)[0] AS firstLinkedDependentNode
  LIMIT 140
   WITH *, coalesce(dependency.weight25PercentInterfaces, dependency.weight, 1) AS weight
   // Use a fixed small pen width for secondary dependencies for better visibility of the more important direct dependency 
   WITH *, "label=" + weight + "; weight=" + weight + "; penwidth=0.3"          AS edgeAttributes
   // Use an even lighter color for secondary dependency edges
   WITH *, edgeAttributes + "; color = 3"                                       AS edgeAttributes
   // Add the last part of the element id to the node name to make it unique.
   WITH *, directDependentNode.name + "_" + split(elementId(directDependentNode), ':')[-1] AS directDependentNodeId
   WITH *, firstLinkedDependentNode.name + "_" + split(elementId(firstLinkedDependentNode), ':')[-1] AS firstLinkedDependentNodeId
   WITH *, "\"" + directDependentNodeId + "\" -> \"" + firstLinkedDependentNodeId + "\""   AS directDependenciesEdge
   WITH *, collect(directDependenciesEdge + " [" + edgeAttributes + "]")                   AS directDependenciesEdges
   WITH *, graphVizOutput + directDependenciesEdges AS graphVizOutput
UNWIND graphVizOutput AS graphVizOutputLine
RETURN DISTINCT graphVizOutputLine