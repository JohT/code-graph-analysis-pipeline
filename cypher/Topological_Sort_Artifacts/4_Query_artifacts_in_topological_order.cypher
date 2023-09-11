//4 Artifacts in topological order

MATCH (artifact:Artifact)
WHERE artifact.topologicalSortIndex IS NOT NULL
 WITH COLLECT(artifact)                   AS artifacts
     ,MAX(artifact.maxDistanceFromSource) AS maxBuildLevel
UNWIND artifacts AS artifact  
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,artifact.topologicalSortIndex                            AS topologicalSortIndex
      ,artifact.maxDistanceFromSource                           AS buildLevel
      ,maxBuildLevel
      ,artifact.incomingDependencies                            AS incomingDependencies
      ,artifact.outgoingDependencies                            AS outgoingDependencies
ORDER BY artifact.topologicalSortIndex