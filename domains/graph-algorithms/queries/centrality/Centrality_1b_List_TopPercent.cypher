// List the top 2% nodes with the highest centrality score.

 MATCH (member)
 WHERE $dependencies_projection_node IN labels(member)
   AND member[$dependencies_projection_write_property] IS NOT NULL
  WITH toInteger(toFloat(count(DISTINCT member)) * 0.02) AS memberCount2Percent
      ,collect(DISTINCT member) AS members
UNWIND members AS member
  WITH memberCount2Percent, member
 ORDER BY member[$dependencies_projection_write_property] DESCENDING    
  WITH memberCount2Percent, collect(DISTINCT member)[0..memberCount2Percent] AS topMembers
 RETURN memberCount2Percent, topMembers