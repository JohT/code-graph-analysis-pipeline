// External SCIP artifact usage overall

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
  WITH e.module                                      AS externalArtifactName
      ,count(DISTINCT m)                             AS numberOfInternalCallerModules
      ,count(DISTINCT i)                             AS numberOfInternalCallerTypes
      ,count(d)                                      AS numberOfTypeCalls
      ,sum(d.referenceCount)                         AS totalReferenceCount
      ,collect(DISTINCT m.name)[0..9]                AS allInternalModules
      ,collect(DISTINCT i.fqn)[0..9]                 AS allInternalTypes
      ,collect(DISTINCT e.name)[0..9]                AS tenExternalTypeNames
RETURN externalArtifactName
      ,numberOfInternalCallerModules
      ,numberOfInternalCallerTypes
      ,numberOfTypeCalls
      ,totalReferenceCount
      ,allInternalModules
      ,allInternalTypes
      ,tenExternalTypeNames
 ORDER BY numberOfInternalCallerModules DESC, externalArtifactName ASC
