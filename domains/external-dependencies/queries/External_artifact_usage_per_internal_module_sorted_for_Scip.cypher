// External SCIP artifact usage per internal module sorted - internal modules ranked by number of external artifacts used.

MATCH (a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
RETURN m.name                   AS internalModuleName
      ,a.name                   AS internalArtifactName
      ,count(DISTINCT e.module) AS numberOfExternalArtifacts
      ,count(DISTINCT e)        AS numberOfExternalTypes
      ,sum(d.referenceCount)    AS totalReferenceCount
 ORDER BY numberOfExternalArtifacts DESC, internalModuleName ASC
