// Explore Typescript elements with same globalFqn

 MATCH (ts1:TS)
 WHERE ts1.globalFqn IS NOT NULL
 MATCH (ts2:TS)
 WHERE ts2.globalFqn IS NOT NULL
   AND ts2.globalFqn = ts1.globalFqn
   AND ts1 <> ts2
RETURN labels(ts1), labels(ts2), count(*)
      ,collect(ts1.globalFqn)[0..4] AS examples1
      ,collect(ts2.globalFqn)[0..4] AS examples2
LIMIT 30