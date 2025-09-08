// Anomaly Detection Summary: Overview of all analyzed code units in total. Requires all other labels/*.cypher queries to run first. Variables: projection_language, projection_node_label

MATCH (codeUnit)
WHERE (codeUnit.incomingDependencies IS NOT NULL 
   OR  codeUnit.outgoingDependencies IS NOT NULL)
  WITH count(DISTINCT codeUnit)                  AS codeUnitCount
      ,sum(codeUnit.anomalyLabel)                AS anomalyCount
      ,sum(sign(codeUnit.anomalyAuthorityRank))  AS authorityCount
      ,sum(sign(codeUnit.anomalyBottleneckRank)) AS bottleNeckCount
      ,sum(sign(codeUnit.anomalyBridgeRank))     AS bridgeCount
      ,sum(sign(codeUnit.anomalyHubRank))        AS hubCount
      ,sum(sign(codeUnit.anomalyOutlierRank))    AS outlierCount
      //,collect(codeUnit.name)[0..4]  AS exampleNames
 RETURN codeUnitCount    AS `Analyzed Units`
       ,anomalyCount     AS `Anomalies`
       ,authorityCount   AS `Authorities`
       ,bottleNeckCount  AS `Bottlenecks`
       ,bridgeCount      AS `Bridges`
       ,hubCount         AS `Hubs`
       ,outlierCount     AS `Outliers`
       //,exampleNames
 ORDER BY anomalyCount DESC, codeUnitCount DESC