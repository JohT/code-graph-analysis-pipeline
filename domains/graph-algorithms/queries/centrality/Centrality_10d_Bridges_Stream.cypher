// Centrality 10d Bridges Stream

CALL gds.bridges.stream($dependencies_projection + '-cleaned')
// The field "remainingSizes" is only needed until https://github.com/neo4j/graph-data-science/issues/354 is resolved.
 YIELD from, to, remainingSizes
  WITH gds.util.asNode(from) AS fromMember
      ,gds.util.asNode(to)   AS toMember
  WITH *, coalesce(fromMember.declaringType + ': ', '')  +
          coalesce(fromMember.rootProjectName + '/', '') +
          coalesce(fromMember.signature,  fromMember.name) AS fromMemberNameWithDetails
  WITH *, coalesce(toMember.declaringType + ': ', '')    +
          coalesce(toMember.rootProjectName + '/', '')   +
          coalesce(toMember.signature,  toMember.name)     AS toMemberNameWithDetails
RETURN coalesce(fromMember.fqn, fromMemberNameWithDetails, fromMember.fileName, fromMember.name) AS fromMemberName
      ,coalesce(toMember.fqn,   toMemberNameWithDetails,   toMember.fileName,   toMember.name)   AS toMemberName
      ,fromMember.incomingDependencies AS fromIncomingDependencies
      ,fromMember.outgoingDependencies AS fromOutgoingDependencies
      ,toMember.incomingDependencies   AS toIncomingDependencies
      ,toMember.outgoingDependencies   AS toOutgoingDependencies