// Explore nodes grouped by their module (first part of globalFqn) and their type of contained symbols

 MATCH (n:TS)
 WHERE n.globalFqn IS NOT NULL
UNWIND labels(n) AS nodeLabel
  WITH replace(split(n.globalFqn, '".')[0],'"', '') AS module
      ,collect(split(n.globalFqn, '".')[1])         AS symbols
      ,nodeLabel
      ,count(DISTINCT n) as numberOfNodes
 WHERE nodeLabel <> 'TS'
RETURN module
      ,collect(DISTINCT nodeLabel) as nodeLabels
      ,numberOfNodes
      ,symbols[0..4] AS symbolExamples
ORDER BY module ASC