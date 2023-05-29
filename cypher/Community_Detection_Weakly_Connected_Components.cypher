//Community Detection Weakly Connected Components
CALL gds.wcc.stream('package-dependencies', {
  relationshipWeightProperty: 'weight'
 ,threshold: 50.0
})
YIELD nodeId, componentId
 WITH componentId, gds.util.asNode(nodeId) AS package
RETURN componentId, count(package) AS members, collect(package.fqn) AS packageNames
ORDER BY componentId