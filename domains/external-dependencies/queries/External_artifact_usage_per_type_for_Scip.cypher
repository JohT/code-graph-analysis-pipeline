// External SCIP artifact usage per internal type (top 100)

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
RETURN i.fqn            AS internalTypeFqn
      ,m.name           AS internalModuleName
      ,e.module         AS externalArtifactName
      ,d.referenceCount AS referenceCount
 ORDER BY referenceCount DESC, internalTypeFqn ASC
 LIMIT 100
