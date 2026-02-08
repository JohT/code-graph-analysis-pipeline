// Anomaly Detection DeepDive: Overview of analyzed code units and the number of anomalies detected. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

 MATCH (codeUnit)
 WHERE $projection_node_label IN labels(codeUnit)
   AND (codeUnit.incomingDependencies > 0 
    OR  codeUnit.outgoingDependencies > 0)
   AND coalesce(codeUnit.testMarkerInteger, 0) = 0
OPTIONAL MATCH (codeUnit)-[dependency:DEPENDS_ON]-(target)
 WHERE $projection_node_label IN labels(target)
   AND (target.incomingDependencies > 0 
    OR  target.outgoingDependencies > 0)
   AND coalesce(target.testMarkerInteger, 0) = 0
  WITH count(dependency)          AS relationshipCount
      ,collect(DISTINCT codeUnit) AS codeUnits
UNWIND codeUnits                  AS codeUnit
  WITH sum(codeUnit.anomalyLabel)                AS anomalyCount
      ,sum(sign(codeUnit.anomalyAuthorityRank))  AS authorityCount
      ,sum(sign(codeUnit.anomalyBottleneckRank)) AS bottleNeckCount
      ,sum(sign(codeUnit.anomalyBridgeRank))     AS bridgeCount
      ,sum(sign(codeUnit.anomalyHubRank))        AS hubCount
      ,sum(sign(codeUnit.anomalyOutlierRank))    AS outlierCount
      ,count(codeUnit)                           AS nodeCount
      ,relationshipCount
      //,collect(codeUnit.name)[0..4]              AS exampleNames
RETURN anomalyCount      AS `Anomalies`
      ,authorityCount    AS `Authorities`
      ,bottleNeckCount   AS `Bottlenecks`
      ,bridgeCount       AS `Bridges`
      ,hubCount          AS `Hubs`
      ,outlierCount      AS `Outliers`
      ,nodeCount         AS `CodeUnits`
      ,relationshipCount AS `Dependencies`
      ,round(toFloat(relationshipCount) / (nodeCount * (nodeCount - 1)), 6) AS `GraphDensity`
     //,exampleNames