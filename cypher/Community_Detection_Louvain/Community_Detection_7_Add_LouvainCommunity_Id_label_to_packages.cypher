//Community Detection 7 Add LouvainCommunity+Id label to packages
//with more than one member

 MATCH (package:Package) 
  WITH package.louvainCommunity25PercentInterfaces AS communityId
      ,collect(package) AS packages
      ,COUNT(DISTINCT package.fqn) AS members
      ,'LouvainCommunity' + toString(package.louvainCommunity25PercentInterfaces) AS labelName
 WHERE members > 1
UNWIND packages AS package
//RETURN communityId, members, packageNames
  CALL apoc.create.addLabels(package, [labelName]) YIELD node
RETURN COUNT(node) as nodesCount