// Explore incoming/outgoing relationship (degree) schema

MATCH (source)-[relation]-(target)
OPTIONAL MATCH (source)<-[incoming]-(target)
OPTIONAL MATCH (source)-[outgoing]->(target)
RETURN labels(source)         AS sourceType
      ,type(incoming)         AS incomingRelationship
      ,type(outgoing)         AS outgoingRelationship
      ,labels(target)         AS dependentType
      ,count(distinct source) AS sourceCount
      ,count(distinct target) AS dependentCount
      ,collect(distinct coalesce(source.globalFqn, source.name, source.referencedGlobalFqn))[0..9] AS sourceNameExamples
      ,collect(distinct coalesce(target.globalFqn, target.name, target.referencedGlobalFqn))[0..9] AS dependentNameExamples
ORDER BY sourceType, dependentType