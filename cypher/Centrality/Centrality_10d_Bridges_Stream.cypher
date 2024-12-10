// Centrality 10d Bridges Stream

CALL gds.bridges.stream($dependencies_projection + '-cleaned')
 YIELD from, to
  WITH gds.util.asNode(from) AS fromMember
      ,gds.util.asNode(to)   AS toMember
OPTIONAL MATCH (fromType:Type)-[:DECLARES]->(fromMember)
  WITH *, coalesce(fromType.fqn + ': ', '')              +
          coalesce(fromMember.rootProjectName + '/', '') +
          coalesce(fromMember.signature,  fromMember.name) AS fromMemberNameWithDetails
OPTIONAL MATCH (toType:Type)-[:DECLARES]->(toMember)
  WITH *, coalesce(toType.fqn + ': ', '')                +
          coalesce(toMember.rootProjectName + '/', '')   +
          coalesce(toMember.signature,  toMember.name)     AS toMemberNameWithDetails
RETURN coalesce(fromMember.fqn, fromMemberNameWithDetails, fromMember.fileName, fromMember.name) AS fromMemberName
      ,coalesce(toMember.fqn,   toMemberNameWithDetails,   toMember.fileName,   toMember.name)   AS toMemberName
      ,fromMember.incomingDependencies AS fromIncomingDependencies
      ,fromMember.outgoingDependencies AS fromOutgoingDependencies
      ,toMember.incomingDependencies   AS toIncomingDependencies
      ,toMember.outgoingDependencies   AS toOutgoingDependencies