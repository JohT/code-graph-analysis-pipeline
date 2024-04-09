// Explore Typescript elements with same globalFqn

 MATCH (ts1:TS)
 WHERE ts1.globalFqn CONTAINS '"'
 MATCH (ts2:TS)
 WHERE ts2.globalFqn CONTAINS '"'
   AND (ts2.globalFqn = ts1.globalFqn
   OR   toLower(ts2.globalFqn) = toLower(ts1.globalFqn))
   AND ts1 <> ts2
RETURN labels(ts1), labels(ts2), count(*)
LIMIT 30