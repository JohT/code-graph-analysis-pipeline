//Community Detection Label Propagation
CALL gds.labelPropagation.stream('package-dependencies', {
  relationshipWeightProperty: 'weight'
 ,maxIterations: 10
})
YIELD nodeId, communityId
 WITH communityId, gds.util.asNode(nodeId) AS package
RETURN communityId, count(package) AS members, collect(package.fqn) AS packageNames
ORDER BY communityId