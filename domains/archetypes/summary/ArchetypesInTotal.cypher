// Archetypes Summary: Overview of all analyzed code units and their archetype labels in total. Requires all other labels/*.cypher queries to run first.

MATCH (codeUnit)
WHERE (codeUnit.incomingDependencies IS NOT NULL 
   OR  codeUnit.outgoingDependencies IS NOT NULL)
  WITH count(DISTINCT codeUnit)                    AS codeUnitCount
      ,sum(sign(codeUnit.archetypeAuthorityRank))  AS authorityCount
      ,sum(sign(codeUnit.archetypeBottleneckRank)) AS bottleNeckCount
      ,sum(sign(codeUnit.archetypeHubRank))        AS hubCount
 RETURN codeUnitCount    AS `Analyzed Units`
       ,authorityCount   AS `Authorities`
       ,bottleNeckCount  AS `Bottlenecks`
       ,hubCount         AS `Hubs`
 ORDER BY authorityCount DESC, codeUnitCount DESC
