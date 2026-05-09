// Archetypes Summary: Overview of analyzed code units and the number of archetypes detected per abstraction layer. Requires all other labels/*.cypher queries to run first.

MATCH (codeUnit)
WHERE (codeUnit.incomingDependencies IS NOT NULL 
   OR  codeUnit.outgoingDependencies IS NOT NULL)
UNWIND labels(codeUnit) AS codeUnitLabel
  WITH *
 WHERE NOT codeUnitLabel STARTS WITH 'Mark4'
   AND NOT codeUnitLabel IN ['File', 'Directory', 'ByteCode', 'GenericDeclaration', 'InternalJavaType', 'ConnectedInternalJavaType']
  WITH collect(codeUnitLabel) AS codeUnitLabels
      ,codeUnit
  WITH apoc.text.join(codeUnitLabels, ',')         AS codeUnitLabels
      ,count(DISTINCT codeUnit)                    AS codeUnitCount
      ,sum(sign(codeUnit.archetypeAuthorityRank))  AS authorityCount
      ,sum(sign(codeUnit.archetypeBottleneckRank)) AS bottleNeckCount
      ,sum(sign(codeUnit.archetypeHubRank))        AS hubCount
 RETURN codeUnitLabels   AS `Abstraction Level`
       ,codeUnitCount    AS `Units`
       ,authorityCount   AS `Authorities`
       ,bottleNeckCount  AS `Bottlenecks`
       ,hubCount         AS `Hubs`
 ORDER BY authorityCount DESC, codeUnitCount DESC
