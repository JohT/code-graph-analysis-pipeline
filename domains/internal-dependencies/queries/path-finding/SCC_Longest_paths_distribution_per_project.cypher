// SCC-level Longest paths distribution per project. Requires "SCC_TopologicalSort_Write.cypher".
// Operates on the SCC component graph (-components projection), not directly on member nodes,
// so that cyclic dependencies are handled: each cycle is a single component node.

CALL gds.dag.longestPath.stream($dependencies_projection + '-components')
YIELD index, sourceNode, targetNode, totalCost
 WITH toInteger(totalCost) AS distance
     ,gds.util.asNode(sourceNode) AS source
     ,gds.util.asNode(targetNode) AS target
WHERE source <> target
  AND source.memberType = $dependencies_projection_node
  AND target.memberType = $dependencies_projection_node
// Compute global statistics per distance before expanding per source project
 WITH distance
     ,count(*)               AS distanceTotalPairCount
     ,count(DISTINCT source) AS distanceTotalSourceCount
     ,count(DISTINCT target) AS distanceTotalTargetCount
     ,collect({source: source, target: target}) AS sourcesAndTargets
UNWIND sourcesAndTargets AS sourceAndTarget
 WITH *
     ,sourceAndTarget.source AS source
     ,sourceAndTarget.target AS target
// Resolve project context via one representative member of the source component
OPTIONAL MATCH (sourceMember)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(source)
OPTIONAL MATCH (targetMember)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(target)
 WITH distance
     ,distanceTotalPairCount
     ,distanceTotalSourceCount
     ,distanceTotalTargetCount
     ,source
     ,target
     ,head(collect(DISTINCT sourceMember)) AS representativeSourceMember
     ,head(collect(DISTINCT targetMember)) AS representativeTargetMember
OPTIONAL MATCH (sourceProject:Project|Artifact|SemanticCodeIndexProject|SemanticCodeIndexArtifact)-[:CONTAINS]->(representativeSourceMember)
OPTIONAL MATCH (targetProject:Project|Artifact|SemanticCodeIndexProject|SemanticCodeIndexArtifact)-[:CONTAINS]->(representativeTargetMember)
RETURN coalesce(sourceProject.name, source.name)         AS sourceProject
      ,coalesce((targetProject <> sourceProject), false) AS isDifferentTargetProject
      ,distance
      ,distanceTotalPairCount
      ,distanceTotalSourceCount
      ,distanceTotalTargetCount
      ,count(*)               AS pairCount
      ,count(DISTINCT source) AS sourceNodeCount
      ,count(DISTINCT target) AS targetNodeCount
      ,collect(DISTINCT source.name + ' -> ' + target.name)[0..4] AS examples
      ,collect(DISTINCT sourceProject.name)[0..4] AS exampleProjects
ORDER BY sourceProject, isDifferentTargetProject, distance
