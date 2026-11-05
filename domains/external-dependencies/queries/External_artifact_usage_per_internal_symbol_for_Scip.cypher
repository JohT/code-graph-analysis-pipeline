// External SCIP artifact usage per internal symbol (type or function, top 100)

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalSymbol)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
RETURN i.fqn            AS internalSymbolFqn
      ,m.name           AS internalModuleName
      ,e.module         AS externalArtifactName
      ,d.referenceCount AS referenceCount
 ORDER BY referenceCount DESC, internalSymbolFqn ASC
 LIMIT 100
