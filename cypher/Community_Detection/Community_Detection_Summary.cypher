// Community Detection Summary. Variables: dependencies_projection_node ("Artifact", "Package", "Type")

MATCH (codeUnit)
WHERE (codeUnit.incomingDependencies > 0 OR codeUnit.outgoingDependencies > 0)
  AND $dependencies_projection_node IN LABELS(codeUnit) 
RETURN coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name)      AS name
      ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', '')) AS shortName
      ,codeUnit.communityLouvainId                  AS louvainId
      ,codeUnit.communityLouvainIntermediateIds     AS louvainIntermediateIds
      ,codeUnit.communityLeidenId                   AS leidenId
      ,codeUnit.communityLeidenIntermediateIds      AS leidenIntermediateIds                   
      ,codeUnit.communityLeidenIdModularity         AS leidenModularity
      ,codeUnit.communityWeaklyConnectedComponentId AS weaklyConnectedComponentId
      ,codeUnit.communityLabelPropagationId         AS labelPropagationId
      ,codeUnit.communityKCoreDecompositionValue    AS kCoreDecompositionValue
      ,codeUnit.communityMaximumKCutId              AS maximumKCutId
      ,codeUnit.incomingDependencies                AS incomingDependencies
      ,codeUnit.outgoingDependencies                AS outgoingDependencies