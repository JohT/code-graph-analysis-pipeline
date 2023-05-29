//Community Detection for Types 2 Leiden Estimate Memory

CALL gds.beta.leiden.write.estimate('type-dependencies', {
  maxLevels: 10,
  tolerance: 0.000001,
  relationshipWeightProperty: 'weight',
  writeProperty: 'leidenTypeCommunityId'
})