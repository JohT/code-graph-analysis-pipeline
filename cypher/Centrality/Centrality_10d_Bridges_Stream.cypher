// Centrality 10d Bridges Stream

CALL gds.bridges.stream($dependencies_projection + '-cleaned')
 YIELD from, to
  WITH gds.util.asNode(from) AS fromMember
      ,gds.util.asNode(to)   AS toMember
  WITH *
      ,toMember.rootProjectName + '/' + toMember.name     AS toMemberNameWithRoot
      ,fromMember.rootProjectName + '/' + fromMember.name AS fromMemberNameWithRoot
RETURN coalesce(fromMember.fqn, fromMemberNameWithRoot, fromMember.name, fromMember.fileName) AS fromMemberName
      ,coalesce(toMember.fqn,   toMemberNameWithRoot,   toMember.name,   toMember.fileName)   AS toMemberName
      ,fromMember.incomingDependencies AS fromIncomingDependencies
      ,fromMember.outgoingDependencies AS fromOutgoingDependencies
      ,toMember.incomingDependencies   AS toIncomingDependencies
      ,toMember.outgoingDependencies   AS toOutgoingDependencies