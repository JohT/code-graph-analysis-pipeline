// Anomaly Detection DeepDive: Overview of analyzed code units and the number of anomalies detected. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

MATCH (codeUnit)
WHERE $projection_node_label IN labels(codeUnit)
  AND (codeUnit.incomingDependencies IS NOT NULL 
   OR  codeUnit.outgoingDependencies IS NOT NULL)
  WITH sum(codeUnit.anomalyLabel)                AS anomalyCount
      ,sum(sign(codeUnit.anomalyAuthorityRank))  AS authorityCount
      ,sum(sign(codeUnit.anomalyBottleneckRank)) AS bottleNeckCount
      ,sum(sign(codeUnit.anomalyBridgeRank))     AS bridgeCount
      ,sum(sign(codeUnit.anomalyHubRank))        AS hubCount
      ,sum(sign(codeUnit.anomalyOutlierRank))    AS outlierCount
      //,collect(codeUnit.name)[0..4]              AS exampleNames
 RETURN anomalyCount     AS `Anomalies`
       ,authorityCount   AS `Authorities`
       ,bottleNeckCount  AS `Bottlenecks`
       ,bridgeCount      AS `Bridges`
       ,hubCount         AS `Hubs`
       ,outlierCount     AS `Outliers`
      //,exampleNames