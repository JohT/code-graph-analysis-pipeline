// Anomaly Detection Graphs: Find top nodes marked as "central" including their incoming dependencies and output them in Graphviz format.

// Step 1: Query overall statistics, e.g. min/max weight for later normalization
 MATCH (sourceForStatistics)-[dependencyForStatistics:DEPENDS_ON]->(targetForStatistics)
 WHERE $projection_node_label IN labels(sourceForStatistics)
   AND $projection_node_label IN labels(targetForStatistics)
  WITH max(coalesce(dependencyForStatistics.weight25PercentInterfaces, dependencyForStatistics.weight)) AS maxWeight
      ,percentileDisc(sourceForStatistics.communityLocalClusteringCoefficient, 0.10) AS localClusteringCoefficientLowThreshold
// Step 2: Query selected central node
 MATCH (central)
 WHERE $projection_node_label IN labels(central)
   AND central.anomalyHubRank = toInteger($projection_node_rank)
  WITH maxWeight
      ,localClusteringCoefficientLowThreshold
      ,central
      ,"Top Rank #" + $projection_node_rank + " " + $projection_language + " " + $projection_node_label + " Hub\\n"  AS graphLabel
      ,coalesce(central.fqn, central.globalFqn, central.fileName, central.signature, central.name)                   AS targetName
  WITH *, "\\n\\nnodes: incoming dependencies (limited max. 40)\\n"                                  AS graphLegend
  WITH *, graphLegend + "node value: local clustering coefficient\\n"                                AS graphLegend
  WITH *, graphLegend + "thick outline: <1 0% percentile of local clustering coefficient\\n"         AS graphLegend
  WITH *, ["graph   [label=\"" + graphLabel + targetName + graphLegend + "\\n\"];"]       AS graphVizOutput
  WITH *, "🎡 hub #" + central.anomalyHubRank + "\\n" + central.name                      AS centralNodeLabel
  WITH *, centralNodeLabel + "\\n(in-degree=" + central.incomingDependencies + ")"        AS centralNodeLabel                    
  WITH *, graphVizOutput + ["central [label=\"" + centralNodeLabel + "\"];"]              AS graphVizOutput
// Step 3: Query direct incoming dependencies to the central node
 MATCH (source)-[dependency:DEPENDS_ON]->(central)
  WHERE $projection_node_label IN labels(source)
    AND source.outgoingDependencies > 0
  ORDER BY dependency.weight DESC, source.name ASC
  LIMIT 50
   WITH *, coalesce(dependency.weight25PercentInterfaces, dependency.weight, 1) AS weight
   WITH *, round((toFloat(weight) / toFloat(maxWeight) * 2.5) + 0.4, 1.0)       AS penWidth
   WITH *, "label=" + weight + "; weight=" + weight + "; penwidth=" + penWidth  AS edgeAttributes
   WITH *, CASE WHEN source.communityLocalClusteringCoefficient <= localClusteringCoefficientLowThreshold 
                THEN 5 ELSE 2 END                                               AS scaledNodeBorder
   WITH *, round(source.communityLocalClusteringCoefficient, 2)                 AS labelValue
   // Add the last part of the element id to make the node name unique, even if the name itself isn't.
   WITH *, source.name + "_" + split(elementId(source), ':')[-1]                AS sourceId
   // Split long names like inner classes identified by a dollar sign ($)
   WITH *, "penwidth = " + scaledNodeBorder + "; "                              AS directInBorder
   WITH *, replace(source.name, '$', '$\\n')                                    AS sourceNameSplit
   WITH *, "label = \"" + sourceNameSplit + "\\n(" + labelValue + ")\"; "       AS directInLabel
   WITH *, " [" + directInLabel + directInBorder + "]; "                        AS directInNodeProperties
   WITH *, "\"" + sourceId + "\" " + directInNodeProperties                     AS directInNode
   WITH maxWeight
       ,central
       ,graphVizOutput 
       ,collect(source) AS directDependentNodes
       ,collect(directInNode + "\"" + sourceId + "\" -> central [" + edgeAttributes + "];")    AS directInEdges
   WITH *, graphVizOutput + directInEdges AS graphVizOutput
// Step 4: Query dependencies between direct dependencies outside the central node
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
   WITH *, "weight=" + weight + "; penwidth=0.2"                                AS edgeAttributes
   // Add the last part of the element id to the node name to make it unique.
   WITH *, directDependentNode.name + "_" + split(elementId(directDependentNode), ':')[-1]           AS directDependentNodeId
   WITH *, firstLinkedDependentNode.name + "_" + split(elementId(firstLinkedDependentNode), ':')[-1] AS firstLinkedDependentNodeId
   WITH *, "\"" + directDependentNodeId + "\" -> \"" + firstLinkedDependentNodeId + "\""             AS directDependenciesEdge
   WITH *, collect(directDependenciesEdge + " [" + edgeAttributes + "]")                             AS directDependenciesEdges
   WITH *, graphVizOutput + directDependenciesEdges AS graphVizOutput
UNWIND graphVizOutput AS graphVizOutputLine
RETURN DISTINCT graphVizOutputLine