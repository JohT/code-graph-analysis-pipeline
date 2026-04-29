// List the top centrality nodes with a 99.5 percentile or higher 

 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member)
   AND member[$dependencies_projection_write_property] IS NOT NULL
  WITH count(DISTINCT member)   AS memberCount
      ,percentileDisc(member[$dependencies_projection_write_property], 0.995) AS centralityPercentile995
      ,collect(DISTINCT member) AS members
UNWIND members AS member
  WITH memberCount
      ,centralityPercentile995
      ,member
 ORDER BY member[$dependencies_projection_write_property] DESCENDING    
 WHERE member[$dependencies_projection_write_property] >= centralityPercentile995
  WITH memberCount
      ,centralityPercentile995
      ,max(member[$dependencies_projection_write_property]) AS maxCentrality
      ,collect(DISTINCT member)       AS topMembers
 RETURN memberCount
       ,maxCentrality
       ,centralityPercentile995
       ,topMembers