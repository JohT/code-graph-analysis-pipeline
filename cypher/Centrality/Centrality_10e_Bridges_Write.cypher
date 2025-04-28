// Centrality 10e Bridges Stream - Write Relationship Property "isBridge"

CALL gds.bridges.stream($dependencies_projection + '-cleaned')
// The field "remainingSizes" is only needed until https://github.com/neo4j/graph-data-science/issues/354 is resolved.
 YIELD from, to, remainingSizes
  WITH gds.util.asNode(from) AS fromMember
      ,gds.util.asNode(to)   AS toMember
 MATCH (fromMember)-[dependency:DEPENDS_ON]-(toMember)
   SET dependency.isBridge = true
RETURN count(*) AS numberOfBridges