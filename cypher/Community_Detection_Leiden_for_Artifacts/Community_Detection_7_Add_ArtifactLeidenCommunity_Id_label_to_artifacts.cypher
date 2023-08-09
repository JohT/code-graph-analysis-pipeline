//Community Detection 7 Add ArtifactLeidenCommunity+Id label to artifacts
//with more than one member

 MATCH (artifact:Artifact:Archive) 
  WITH artifact.leidenCommunityId AS communityId
      ,collect(artifact) AS artifacts
      ,COUNT(DISTINCT artifact.fileName) AS members
      ,'ArtifactLeidenCommunity' + toString(artifact.leidenCommunityId) AS labelName
 WHERE members > 1
UNWIND artifacts AS artifact
  CALL apoc.create.addLabels(artifact, [labelName]) YIELD node
RETURN COUNT(node) as nodesCount