//Community Detection for Types 3 Leiden Write

CALL gds.beta.leiden.write('type-dependencies', {
  maxLevels: 10,
  gamma: 7.0,
  theta: 0.001,
  tolerance: 0.0000001,
  relationshipWeightProperty: 'weight',
  consecutiveIds: true,
  writeProperty: 'leidenTypeCommunityIdGamma7'
})