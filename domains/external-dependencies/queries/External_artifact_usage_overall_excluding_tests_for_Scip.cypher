// External SCIP artifact usage overall, excluding test modules.

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalSymbol)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
WHERE coalesce(m.isTest, false) = false
  WITH e.module                                      AS externalArtifactName
      ,count(DISTINCT m)                             AS numberOfInternalCallerModules
      ,count(DISTINCT i)                             AS numberOfInternalCallerSymbols
      ,count(d)                                      AS numberOfSymbolCalls
      ,sum(d.referenceCount)                         AS totalReferenceCount
      ,collect(DISTINCT m.name)[0..9]                AS allInternalModules
      ,collect(DISTINCT i.fqn)[0..9]                 AS allInternalSymbols
      ,collect(DISTINCT e.name)[0..9]                AS tenExternalTypeNames
RETURN externalArtifactName
      ,numberOfInternalCallerModules
      ,numberOfInternalCallerSymbols
      ,numberOfSymbolCalls
      ,totalReferenceCount
      ,allInternalModules
      ,allInternalSymbols
      ,tenExternalTypeNames
 ORDER BY numberOfInternalCallerModules DESC, externalArtifactName ASC
