// Community Metrics

  CALL gds.conductance.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD community AS communityId, conductance
  WITH collect({communityId: communityId, conductance: conductance}) AS conductances
  CALL gds.modularity.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
  WITH conductances
      ,collect({communityId: communityId, modularity: modularity}) AS modularities
 MATCH (member)
 WHERE member[$dependencies_projection_write_property] IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member)
  WITH conductances
      ,modularities
      ,member[$dependencies_projection_write_property]                               AS communityId
      ,coalesce(member.fqn, member.fileName, member.name)                            AS memberName
      ,coalesce(member.name, replace(last(split(member.fileName, '/')), '.jar', '')) AS shortMemberName
  WITH conductances
      ,modularities
      ,communityId
      ,count(DISTINCT memberName)        AS memberCount
      ,collect(DISTINCT shortMemberName) AS shortMemberNames
      ,collect(DISTINCT memberName)      AS memberNames
      ,reduce(memberConductance = 0, conductance IN conductances | 
        CASE conductance.communityId WHEN communityId THEN conductance.conductance 
        ELSE memberConductance END)      AS conductance
      ,reduce(memberModularity = 0, modularity IN modularities | 
        CASE modularity.communityId WHEN communityId THEN modularity.modularity 
        ELSE memberModularity END)       AS modularity
 RETURN communityId
       ,conductance
       ,modularity
       ,memberCount
       ,shortMemberNames[0..9] AS someMemberNamesShort
       ,memberNames[0..9]      AS someMemberNames
ORDER BY communityId ASCENDING