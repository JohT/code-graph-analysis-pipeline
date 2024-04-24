// Explore nodes grouped by their module (first part of globalFqn)

 MATCH (n:TS)
 WHERE n.globalFqn IS NOT NULL
UNWIND labels(n) AS nodeLabel
  WITH replace(split(n.globalFqn, '".')[0],'"', '') AS module
      ,collect(split(n.globalFqn, '".')[1])         AS symbols
      ,nodeLabel
      ,count(DISTINCT n) as numberOfNodes
 WHERE nodeLabel <> 'TS'
RETURN module
      ,collect(DISTINCT nodeLabel) AS nodeLabels
      ,sum(numberOfNodes)          AS numberOfNodes
      ,collect(symbols[0..4])      AS symbolExamples
ORDER BY module ASC